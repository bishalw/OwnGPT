//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine


@MainActor
final class ConversationViewModel: ObservableObject {
    
    @Published var isSendButtonDisabled = true
    @Published private(set) var showPlaceholder = true
    @Published var conversation: Conversation?
    var messages: [Message]{
        conversation?.messages ?? []
    }
    @Published var inputMessage = ""
    {
        didSet { updateSendButtonState() }
    }
    
    private let store: ConversationStoreProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var messageIsStreaming: Bool {
        messages.contains { $0.isStreaming }
    }
    var createNewConversation: () -> Void
    
    init(store: ConversationStoreProtocol,
         createNewConversation: @escaping () -> Void) {
        self.createNewConversation = createNewConversation
        self.store = store
        self.conversation = store.conversation
        setupBindings()
        updatePlaceholderVisibility()
    }
    
    private func setupBindings() {
        store.conversationPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] conversation in
                guard let self = self else { return }
                self.conversation = conversation
                self.updatePlaceholderVisibility()
            }
            .store(in: &cancellables)
        
    }
    
    func sendTapped() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSendButtonDisabled.toggle()
        send(text: inputMessage)
        inputMessage = ""
    }
    
    func createNewConversationButtonPressed() {
        self.createNewConversation()
    }
    
    func send(text: String) {
        store.sendMessage(string: text)
    }
    
    private func updatePlaceholderVisibility() {
        showPlaceholder = messages.isEmpty
    }
    
    private func updateSendButtonState() {
        isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

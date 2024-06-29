//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine

protocol ConversationViewModelSharedProvider {
    var selectedConversationPublisher: Published<Conversation?> { get }
}

@MainActor
final class ConversationViewModel: ObservableObject {
    @Published var isSendButtonDisabled = true
    @Published private(set) var showPlaceholder = true
    @Published private(set) var messages: [Message] = []
    @Published var selectedConversation: Conversation?
    @Published var inputMessage = "" {
        didSet { updateSendButtonState() }
    }
    
    private let store: ConversationStore
    private var cancellables = Set<AnyCancellable>()
    
    var messageIsStreaming: Bool {
        messages.contains { $0.isStreaming }
    }
    
    private(set) var conversation: Conversation
    
    init(store: ConversationStore, conversationViewModelSharedProvider: ConversationViewModelSharedProvider) {
        self.store = store
        self.conversation = Conversation(id: UUID(), messages: []) // Initialize with an empty conversation
        self._selectedConversation = conversationViewModelSharedProvider.selectedConversationPublisher
        setupBindings()
        updatePlaceholderVisibility()
    }
    
    private func setupBindings() {
        store.conversation
            .receive(on: RunLoop.main)
            .sink { [weak self] conversation in
                guard let self = self else { return }
                self.conversation = conversation
                self.messages = conversation.messages
                self.updatePlaceholderVisibility()
            }
            .store(in: &cancellables)
        
        $selectedConversation
            .compactMap { $0 }
            .sink { [weak self] conversation in
                self?.updateSelectedConversation(conversation)
            }
            .store(in: &cancellables)
    }

    private func updateSelectedConversation(_ conversation: Conversation) {
        guard self.conversation.id != conversation.id else { return }
        Log.shared.debug("Updating selected conversation in ViewModel: \(conversation.id)")
        self.store.updateWithSelectedConversation(conversation)
    }
    
    func sendTapped() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSendButtonDisabled.toggle()
        if messages.isEmpty {
            createNewConversation()
        }
        send(text: inputMessage)
        inputMessage = ""
    }
    
    func send(text: String) {
        store.sendMessage(string: text)
    }
    
    func createNewConversation() {
        let newConversation = store.createNewConversation()
        self.conversation = newConversation
        self.messages = newConversation.messages
        inputMessage = ""
        updateSendButtonState()
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        showPlaceholder = messages.isEmpty
    }
    
    private func updateSendButtonState() {
        isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine
import SwiftUI

@MainActor
final class ConversationViewModel: ObservableObject {
    
    @Published var isSendButtonDisabled = true
    @Published private(set) var showPlaceholder = true
    @Published var conversation: Conversation?
    @Published var inputMessage = "" { didSet { updateSendButtonState() } }
    
    var messages: [Message] { conversation?.messages ?? [] }
    var messageIsStreaming: Bool { messages.contains { $0.isStreaming } }
    var createNewConversation: () -> Void
    
    private let store: ConversationStore
    private var cancellables = Set<AnyCancellable>()

    
    init(store: ConversationStore,
         createNewConversation: @escaping () -> Void) 
    {
        self.createNewConversation = createNewConversation
        self.store = store
        self.conversation = store.conversation
        setupBindings()
        updatePlaceholderVisibility()
    }
    
    //MARK: Public
    
    func sendTapped() {
        guard !inputMessage.isBlank else { return }
        isSendButtonDisabled.toggle()
        send(text: inputMessage)
        inputMessage = ""
    }
    func createNewConversationButtonPressed() {
        self.createNewConversation()
    }
    
    //MARK: Private
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

    private func send(text: String) {
        store.sendMessage(string: text)
    }
    
    private func updatePlaceholderVisibility() {
        showPlaceholder = messages.isEmpty
    }
    
    private func updateSendButtonState() {
        isSendButtonDisabled = inputMessage.isBlank
    }
}


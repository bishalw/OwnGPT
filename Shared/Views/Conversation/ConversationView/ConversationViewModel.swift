//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine

@MainActor
final class ConversationViewModel: ObservableObject {
    
    @Published var isStreaming: Bool = false
    @Published var isSendButtonDisabled: Bool = true
    @Published var messages: [Message] = []
    
    @Published var inputMessage: String = "" {
        didSet {
            isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var store: ConversationStore
    
    init(store: ConversationStore) {
        self.store = store
        setupBindings()
    }
    
    private func setupBindings(){
        store.$conversation
            .map {$0.messages}
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
    }
    
    func sendTapped()  {
    
        isSendButtonDisabled = true
        let text = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputMessage = ""
         store.sendMessage(string:text)
    }
    
    func retry(message: Message)   {
        if case let .message(string: text) = message.content {
         store.sendMessage(string: text)
        }
    }
    func removeMessage(at index: Int) {
        store.conversation.messages.remove(at: index)
    }
    
    func clearMessages() {
        
    }
    
    func send(text: String)  {
          store.sendMessage(string: text)
    }
}

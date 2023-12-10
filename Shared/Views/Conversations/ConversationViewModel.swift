//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import SwiftUI
import Combine

final class ConversationViewModel: ObservableObject  {
    
    @Published var isStreaming: Bool = false
    @Published var isSendButtonDisabled: Bool = true
    @Published var isTextFieldFocused = false
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
        
        @MainActor
        func sendTapped() async  {
            isTextFieldFocused = true
            isSendButtonDisabled = true
            let text = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { return }
            inputMessage = ""
            await store.send(text)
            // updateConversation(conversation)
            // updateConversationInCoreData(conversation)
            //saveConversationToCoreData()
        }
        
        @MainActor
        func retry(message: Message) async {
            guard let index = store.messages.firstIndex(where: { $0.id == message.id}) else {
                return
            }
            removeMessage(at: index)
            if case let .message(string: text) = message.content {
                await send(text: text)
            }
        }
        func removeMessage(at index: Int) {
            store.conversation.messages.remove(at: index)
        }
        @MainActor
        func clearMessages() {
            store.deleteHistoryList()
            withAnimation {
                store.conversation.messages.removeAll()
            }
            //        updateConversation(conversation)
        }
        
        
        @MainActor
        func send(text: String) async {
            await store.send(text)
        }
    
}

//
//  ChatsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 8/6/23.
//

import Foundation
import SwiftUI
import Combine

class ConversationsViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isNewChatActive: Bool = false
    private var store: ConversationsStore
    init(store: ConversationsStore) {
        self.store = store
    }
    func updateConversation(_ conversation: Conversation) {
            if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
                conversations[index] = conversation
            }
        }
     func startNewConversation() {
           let newConversation = Conversation(id: UUID(), messages: [])
           conversations.append(newConversation)
           isNewChatActive = true
    }
    
}

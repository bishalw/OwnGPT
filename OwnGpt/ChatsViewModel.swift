//
//  ChatsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 8/6/23.
//

import Foundation
class ChatsViewModel: ObservableObject {
    @Published var chats: [Conversation] = []
    @Published var isNewChatActive: Bool = false
    
    func updateConversation(_ conversation: Conversation) {
            if let index = chats.firstIndex(where: { $0.id == conversation.id }) {
                chats[index] = conversation
            }
        }
     func startNewChat() {
           let newConversation = Conversation(id: UUID(), messages: [])
           chats.append(newConversation)
           isNewChatActive = true
    }
    
}

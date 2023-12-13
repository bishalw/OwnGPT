//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ConversationsView: View {
    @StateObject var conversationsViewModel : ConversationsViewModel
    @EnvironmentObject var store: ConversationStore
    var body: some View {
        
        NavigationStack {
            List(conversationsViewModel.conversations, id: \.id) { chat in
                // -MARK: - Navigate to Conversation
//                NavigationLink(destination: chatDetailView(for: chat)) {
//                    ConversationRow(conversation: chat)
//                }
            }
        }
        .navigationTitle("Conversations")
        .toolbar {
            HeaderView()
        }
    }
    @ToolbarContentBuilder func HeaderView() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: conversationsViewModel.startNewConversation) {
                Label("New Chat", systemImage: "square.and.pencil")
            }
        }
    }
    @ViewBuilder func Conversation(conversation: Conversation) -> some View {
        if let lastMessage = conversation.messages.last {
          Text(lastMessage.content.text)
        } else {
          Text("No messages")
        }
    }
}
extension Conversation {
    var lastMessageContent: String? {
        return messages.last?.content.text
    }
}

#Preview {
    ConversationsView(conversationsViewModel: .init())
}

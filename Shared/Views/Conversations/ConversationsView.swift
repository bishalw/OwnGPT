//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ConversationsView: View {
    @StateObject var conversationsViewModel : ConversationsViewModel
    @EnvironmentObject var core: Core
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(conversationsViewModel.conversations, id: \.id) { chat in
                    // -MARK: - Navigate to Conversation
                    // NavigationLink(destination: chatDetailView(for: chat)) {
                    ConversationTitle(conversation: chat)
                    //                }
                }.onDelete(perform: { indexSet in
        
                })
            }
        }
        .navigationTitle("Conversations")
    }

    @ViewBuilder func ConversationTitle(conversation: Conversation) -> some View {
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
struct HeaderView: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                // Add your action here
            }) {
                Image(systemName: "square.and.pencil")
            }
        }
    }
}

struct Test: View {
    var body: some View {
        NavigationView {
            Text("Content View")
                .toolbar {
                    HeaderView()
                }
        }
    }
}

struct Test_Views: PreviewProvider {
    static var previews: some View {
        Test()
    }
}

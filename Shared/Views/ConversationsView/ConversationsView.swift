//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ConversationsView: View {
    @StateObject var conversationsViewModel : ConversationsViewModel
    var body: some View {
        
        NavigationStack {
            List(conversationsViewModel.conversations, id: \.id) { chat in
                
                NavigationLink(destination: chatDetailView(for: chat)) {
                    ConversationRow(conversation: chat)
                }
            }
        }
        .navigationTitle("Chat History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: conversationsViewModel.startNewConversation) {
                    Label("New Chat", systemImage: "square.and.pencil")
                }
            }
        }
        .navigationDestination(isPresented: $conversationsViewModel.isNewChatActive) {
            if let lastChat = conversationsViewModel.conversations.last {
                          chatDetailView(for: lastChat)
                      } else {
                          Text("Failed to create new chat.")
                      }
        }
        
    }
    
//    private func startNewChat() {
//           let newConversation = Conversation(id: UUID(), messages: [])
//           chatsViewModel.chats.append(newConversation)
//           isNewChatActive = true
//    }
    private func chatDetailView(for conversation: Conversation) -> some View {
        
        let transformedHistory = conversation.messages.map { $0.toOpenAiMessage }
        
//        return ChatScreenView(chatScreenViewModel: ChatScreenViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey), history: transformedHistory, conversation: conversation, retryCallback: { _ in }, updateConversation: chatsViewModel.updateConversation(_:)))
        
        return ConversationView(conversationViewModel: ConversationViewModel(store: ))
        }
    
}


struct ConversationRow: View {
  let conversation: Conversation
  
  var body: some View {
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

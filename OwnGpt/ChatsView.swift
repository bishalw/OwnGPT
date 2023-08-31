//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ChatsView: View {
    @StateObject var chatsViewModel : ChatsViewModel
    
    var body: some View {
        
        NavigationStack {
            List(chatsViewModel.chats, id: \.id) { chat in
                
                NavigationLink(destination: chatDetailView(for: chat)) {
                    ChatListRow(conversation: chat)
                }
            }
        }
        .navigationTitle("Chat History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: chatsViewModel.startNewChat) {
                                   Label("New Chat", systemImage: "square.and.pencil")
                               }
            }
        }
        .navigationDestination(isPresented: $chatsViewModel.isNewChatActive) {
            if let lastChat = chatsViewModel.chats.last {
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
        
        return ChatScreenView(chatScreenViewModel: ChatScreenViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey), history: transformedHistory, conversation: conversation, retryCallback: { _ in }, updateConversation: chatsViewModel.updateConversation(_:)))
        }
    
}


struct ChatListRow: View {
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
    ChatsView(chatsViewModel: .init())
}

//
//  ConversationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/31/23.
//

import Foundation

class ConversationStore: ObservableObject {
    
    @Published var conversation: Conversation
    
    var messages: [Message] {
        return conversation.messages
    }
    
    private let conversationRepository: ConversationsRepository
    
    init(conversationRepository: ConversationsRepository,initialConversation: Conversation? = nil){
        self.conversationRepository = conversationRepository
        self.conversation = initialConversation ?? Conversation(id: UUID(), messages: [])
        addSubscriber()
    }
    private func addSubscriber() {
        Task {
            for await value in conversationRepository.$historyList.values {
                await MainActor.run {
                    self.conversation.messages =  value.map{ Message(from: $0) }
                }
            }
        }
    }
    func send(_ text: String) async {
        do {
            let userMessage = Message(id: UUID(), type: .user, content: .message(string: text), isStreaming: true)
            
            Task { @MainActor in
                self.conversation.messages.append(userMessage)
            }
            
            let responseText = try await conversationRepository.sendMessage(text)
            
            Task { @MainActor in
                if var lastMessage = self.conversation.messages.last, lastMessage.isStreaming {
                    // Append to existing message if it's part of the stream
                    switch lastMessage.content {
                    case .message(let existingText):
                        lastMessage.content = .message(string: existingText + responseText)
                    default:
                        break
                    }
                    self.conversation.messages[self.conversation.messages.count - 1] = lastMessage
                } else {
                    // Create a new message if not part of the stream
                    let responseMessage = Message(id: UUID(), type: .system, content: .message(string: responseText), isStreaming: false)
                    self.conversation.messages.append(responseMessage)
                }
            }
            
        } catch {
            print("Error in sendMessage: \(error)")
        }
    }
    
    func deleteHistoryList() {
        self.conversation.messages = []
    }
    
}

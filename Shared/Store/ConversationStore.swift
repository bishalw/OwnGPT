//
//  ConversationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/31/23.
//

import Foundation

class ConversationStore: ObservableObject {
    @Published var conversation: Conversation
    
    var chatGPTAPI: ChatGPTAPI
    var repo: ConversationRepository
    
    init(chatGPTAPI: ChatGPTAPI,
         conversation: Conversation?,
         repo: ConversationRepository) {
        self.chatGPTAPI = chatGPTAPI
        self.repo = repo
        self.conversation = conversation ?? .init(id: UUID(), messages: [])
    }
    
    func sendMessage(string: String) async throws {
        addConversation(message: .init(id: .init(),
                                       type: .user,
                                       content: .message(string: string),
        
                                       isStreaming: false))
        
        repo.save(conversation: conversation)
        
        addConversation(message: .init(id: .init(),
                                       type: .system,
                                       content: .message(string: ""),
                                       isStreaming: true))
        
        
        
        do {
            let responseStream = try await chatGPTAPI.sendMessageStream(text: string, history: conversation.getOpenApiHistory())
            
            
            var fullResponse = ""
            for try await messageContent in responseStream {
                fullResponse += messageContent
                
                updateConversationLastMessage(message: .init(id: .init(),
                                                             type: .system,
                                                             content: .message(string: fullResponse),
                                                             isStreaming: true))
                print("Received and added response to historyList: \(fullResponse)")
            }
            
            updateConversationLastMessage(message: .init(id: UUID(),
                                                type: .system,
                                                content: .message(string: fullResponse),
                                                isStreaming: false))
            repo.save(conversation: conversation)
        } catch {
            print("Error in sendMessage: \(error)")
            throw error
        }
    }
    
    private func addConversation(message: Message) {
        var currentMessage = conversation.messages
        currentMessage.append(message)
        self.conversation = Conversation(id: conversation.id,
                                        messages: currentMessage)
    }
    
    private func updateConversationLastMessage(message: Message) {
        var currentMessage = conversation.messages
        currentMessage.removeLast()
        currentMessage.append(message)
        self.conversation = Conversation(id: conversation.id,
                                        messages: currentMessage)
    }
}

fileprivate extension Conversation {
    func getOpenApiHistory() -> [OpenAiModels.Message] {
        self.messages.map { $0.toOpenAiMessage }
    }
}

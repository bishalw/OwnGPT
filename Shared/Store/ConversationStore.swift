//
//  ConversationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/31/23.
//

import Foundation
import Combine

class ConversationStore: ObservableObject {
    @Published var conversation: Conversation 
    var chatGPTAPI: ChatGPTAPIService
    var repo: ConversationRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(chatGPTAPI: ChatGPTAPIService,
         conversation: Conversation? = nil,
         repo: ConversationRepository) 
    {
        self.chatGPTAPI = chatGPTAPI
        self.repo = repo
        self.conversation = conversation ?? .init(id: UUID(), messages: [])
        
        repo.didUpdateRepo
            .sink { [weak self] update in
                switch update {
                case .updatedConversation(let updatedConversation):
                    if updatedConversation.id == self?.conversation.id {
                        self?.fetchConversation(conversationId: updatedConversation.id)
                    }
                case .updatedConversations:
                    break
                }
            }
            .store(in: &subscriptions)
    }
    func fetchConversation(conversationId: UUID) {
        Task {
            do {
                self.conversation = try await repo.get(conversationId: conversationId)
            } catch {
                
                print("Error fetching conversation: \(error)")
            }
        }
    }
    
    func sendMessage(string: String) {
        // Add user message to conversation on the main thread

        Task {
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
                    
                    // Update conversation with received content on the main thread
                    let systemMessage = Message(id: .init(), type: .system, content: .message(string: fullResponse), isStreaming: true)

                        updateConversationLastMessage(message: systemMessage)
                    
                    
                    print("Received and added response to historyList: \(fullResponse)")
                }
                
                let finalSystemMessage = Message(id: UUID(), type: .system, content: .message(string: fullResponse), isStreaming: false)
                
                updateConversationLastMessage(message: finalSystemMessage)
                
                
                repo.save(conversation: conversation)
            } catch {
                print("Error in sendMessage: \(error)")
            }
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
        if !currentMessage.isEmpty {
            currentMessage.removeLast()
        }
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

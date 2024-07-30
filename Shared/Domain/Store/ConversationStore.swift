//
//  ConversationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/31/23.
//

import Foundation
import Combine

protocol ConversationStoreProtocol: ObservableObject {
    var conversationPublisher: AnyPublisher<Conversation, Never> { get }
//    var conversation: Conversation { get }
    func sendMessage(string: String)
}

class ConversationStore: ConversationStoreProtocol {
    
    // MARK: Private
    private let conversationSubject: CurrentValueSubject<Conversation, Never>
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: Dependency
    private var chatGPTAPI: ChatGPTAPIService
    private var repo: ConversationRepository
    
    //MARK: Public
    var conversationPublisher: AnyPublisher<Conversation, Never> {
        conversationSubject.eraseToAnyPublisher()
    }

   
    init(chatGPTAPI: ChatGPTAPIService, repo: ConversationRepository, conversation: Conversation?) {
        self.chatGPTAPI = chatGPTAPI
        self.repo = repo
        self.conversationSubject = CurrentValueSubject(conversation ?? .init())
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        repo.didUpdateRepo
            .receive(on: RunLoop.main)
            .sink { [weak self] update in
                switch update {
                case .updatedConversation(let conversation):
                    Log.shared.logger.debug("Received updated conversation from repo: \(conversation.id)")
                    self?.conversationSubject.send(conversation)
                case .updatedConversations:
                    Log.shared.logger.debug("Received update for multiple conversations")
                    // Handle if needed
                }
            }
            .store(in: &subscriptions)
    }
    
    func createNewConversation() -> Conversation {
        let newConversation = Conversation(id: UUID(), messages: [])
        Log.shared.logger.debug("Created new conversation with ID: \(newConversation.id)")
        conversationSubject.send(newConversation)
        repo.save(conversation: newConversation)
        return newConversation
    }
    
    func sendMessage(string: String) {
        Task {
            initializeConversation(with: string)
            do {
                let history = conversationSubject.value.getOpenApiHistory()
                
                Log.shared.logger.info("Sending request with text: \(string) and history: \(history)")
                let responseStream = try await chatGPTAPI.sendMessageStream(text: string, history: history)
                Log.shared.logger.info("Response stream received")
                try await processResponseStream(responseStream)
            } catch {
                Log.shared.logger.info("Error in sendMessage: \(error)")
            }
        }
    }
        
    private func initializeConversation(with string: String) {
        addToConversation(message: Message(id: UUID(),
                                         type: .user,
                                         content: .message(string: string),
                                         isStreaming: false))
        
        addToConversation(message: Message(id: UUID(),
                                         type: .system,
                                         content: .message(string: ""),
                                         isStreaming: true))
    }
    
    private func processResponseStream(_ responseStream: AsyncThrowingStream<String, Error>) async throws {
        var fullResponse = ""
        do {
            for try await messageContent in responseStream {
                fullResponse += messageContent
                let systemMessage = Message(id: UUID(), type: .system, content: .message(string: fullResponse), isStreaming: true)
                updateConversationLastMessage(message: systemMessage)
            }
            Log.shared.logger.info("Final response: \(fullResponse)")
            finalizeConversation(with: fullResponse)
        } catch {
            Log.shared.logger.error("Error processing response stream: \(error)")
        }
    }
    
    private func addToConversation(message: Message) {
        var currentMessages = conversationSubject.value.messages
        currentMessages.append(message)
        let updatedConversation = Conversation(id: conversationSubject.value.id, messages: currentMessages)
        Log.shared.logger.debug("Adding message to conversation: \(updatedConversation.id)")
        conversationSubject.send(updatedConversation)
    }
    
    private func updateConversationLastMessage(message: Message) {
        var currentMessages = conversationSubject.value.messages
        if !currentMessages.isEmpty {
            currentMessages.removeLast()
        }
        currentMessages.append(message)
        let updatedConversation = Conversation(id: conversationSubject.value.id, messages: currentMessages)
        Log.shared.logger.debug("Updating last message in conversation: \(updatedConversation.id)")
        conversationSubject.send(updatedConversation)
    }
    
    private func finalizeConversation(with content: String) {
        let finalSystemMessage = Message(id: UUID(),
                                         type: .system,
                                         content: .message(string: content),
                                         isStreaming: false)
        updateConversationLastMessage(message: finalSystemMessage)
        Log.shared.logger.info("Finalized Message: \(finalSystemMessage)")
        repo.save(conversation: conversationSubject.value)
    }
}


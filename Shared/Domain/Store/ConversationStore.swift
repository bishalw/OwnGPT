//
//  ConversationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/31/23.
//

import Foundation
import Combine

protocol ConversationStoreProtocol: AnyObject {
    var conversation: AnyPublisher<Conversation, Never> { get }
    var chatGPTAPI: ChatGPTAPIService { get }
    var repo: ConversationRepository { get }
    func sendMessage(string: String)
    func updateWithSelectedConversation(_ conversation: Conversation)
}

class ConversationStore: ObservableObject, ConversationStoreProtocol {
    private let conversationSubject: CurrentValueSubject<Conversation, Never>
    var conversation: AnyPublisher<Conversation, Never> {
        conversationSubject.eraseToAnyPublisher()
    }
    var chatGPTAPI: ChatGPTAPIService
    var repo: ConversationRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(chatGPTAPI: ChatGPTAPIService, repo: ConversationRepository) {
        self.chatGPTAPI = chatGPTAPI
        self.repo = repo
        
        // Initialize with an empty conversation, but don't create a new one yet
        self.conversationSubject = CurrentValueSubject(Conversation(id: UUID(), messages: []))
        
        setupSubscriptions()
//        fetchInitialConversation()
    }
    
    private func setupSubscriptions() {
        repo.didUpdateRepo
            .receive(on: RunLoop.main)
            .sink { [weak self] update in
                switch update {
                case .updatedConversation(let conversation):
                    Log.shared.debug("Received updated conversation from repo: \(conversation.id)")
                    self?.conversationSubject.send(conversation)
                case .updatedConversations:
                    Log.shared.debug("Received update for multiple conversations")
                    // Handle if needed
                }
            }
            .store(in: &subscriptions)
    }
    
    func createNewConversation() -> Conversation {
        let newConversation = Conversation(id: UUID(), messages: [])
        Log.shared.debug("Created new conversation with ID: \(newConversation.id)")
        conversationSubject.send(newConversation)
        // Optionally, save the new conversation to the repository
        repo.save(conversation: newConversation)
        return newConversation
    }
    func sendMessage(string: String) {
        Task {
            initializeConversation(with: string)
            do {
                let history = conversationSubject.value.getOpenApiHistory()
                
                Log.shared.info("Sending request with text: \(string) and history: \(history)")
                let responseStream = try await chatGPTAPI.sendMessageStream(text: string, history: history)
                Log.shared.info("Response stream received")
                try await processResponseStream(responseStream)
            } catch {
                Log.shared.info("Error in sendMessage: \(error)")
            }
        }
    }
    
    func updateWithSelectedConversation(_ conversation: Conversation) {
        Log.shared.debug("Updating selected conversation: \(conversation.id)")
        Task {
            do {
                let fetchedConversation = try await repo.get(conversationId: conversation.id)
                await MainActor.run {
                    self.conversationSubject.send(fetchedConversation)
                }
            } catch {
                Log.shared.error("Error fetching conversation: \(error)")
            
                await MainActor.run {
                    self.conversationSubject.send(conversation)
                }
            }
        }
    }
    
    private func initializeConversation(with string: String) {
        addConversation(message: Message(id: UUID(),
                                         type: .user,
                                         content: .message(string: string),
                                         isStreaming: false))
        
        addConversation(message: Message(id: UUID(),
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
            Log.shared.info("Final response: \(fullResponse)")
            finalizeConversation(with: fullResponse)
        } catch {
            Log.shared.error("Error processing response stream: \(error)")
        }
    }
    
    private func addConversation(message: Message) {
        var currentMessages = conversationSubject.value.messages
        currentMessages.append(message)
        let updatedConversation = Conversation(id: conversationSubject.value.id, messages: currentMessages)
        Log.shared.debug("Adding message to conversation: \(updatedConversation.id)")
        conversationSubject.send(updatedConversation)
    }
    
    private func updateConversationLastMessage(message: Message) {
        var currentMessages = conversationSubject.value.messages
        if !currentMessages.isEmpty {
            currentMessages.removeLast()
        }
        currentMessages.append(message)
        let updatedConversation = Conversation(id: conversationSubject.value.id, messages: currentMessages)
        Log.shared.debug("Updating last message in conversation: \(updatedConversation.id)")
        conversationSubject.send(updatedConversation)
    }
    
    private func finalizeConversation(with content: String) {
        let finalSystemMessage = Message(id: UUID(),
                                         type: .system,
                                         content: .message(string: content),
                                         isStreaming: false)
        updateConversationLastMessage(message: finalSystemMessage)
        Log.shared.info("Finalized Message: \(finalSystemMessage)")
        repo.save(conversation: conversationSubject.value)
    }
}

fileprivate extension Conversation {
    func getOpenApiHistory() -> [OpenAiModels.Message] {
        self.messages.map { $0.toOpenAiMessage }
    }
}

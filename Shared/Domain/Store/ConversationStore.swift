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
    func printConversationCount()
    func loadFirstConversation() async throws -> Conversation?
}

class ConversationStore: ObservableObject, ConversationStoreProtocol {
    
    private let conversationSubject: CurrentValueSubject<Conversation, Never>
    var conversation: AnyPublisher<Conversation, Never> {
        conversationSubject.eraseToAnyPublisher()
    }
    var chatGPTAPI: ChatGPTAPIService
    var repo: ConversationRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(chatGPTAPI: ChatGPTAPIService,
         conversation: Conversation? = nil,
         repo: ConversationRepository)
    {
        self.chatGPTAPI = chatGPTAPI
        self.repo = repo
        self.conversationSubject = CurrentValueSubject(conversation ?? .init(id: UUID(), messages: []))
        setupSubscriptions()
        fetchInitialConversation()
    }
    
    func createNewConversation() {
        let newConversation = Conversation(id: UUID(), messages: [])
        conversationSubject.send(newConversation)
//        Log.shared.debug("Created new conversation with ID: \(newConversation.id)")
    }
    func loadFirstConversation() async throws -> Conversation? {
        if let firstConversation = try await repo.getFirstConversation() {
            self.conversationSubject.send(firstConversation)
            return firstConversation
        } else {
            Log.shared.info("No conversations found.")
            return nil
        }
    }
    
    func sendMessage(string: String) {
        Task {
            initializeConversation(with: string)
            do {
                let history = conversationSubject.value.getOpenApiHistory()
                
                Log.shared.info("Sending request with text: \(string) and history: \(history)")
                Log.shared.info("Sending request with text: \(string) and history: \(history)")
                let responseStream = try await chatGPTAPI.sendMessageStream(text: string, history: history)
                Log.shared.info("Response stream received")
                try await processResponseStream(responseStream)
            } catch {
                Log.shared.info("Error in sendMessage: \(error)")
            }
        }
    }
    
    func printConversationCount() {
        Task {
            do {
                let count = try await repo.getConversationCount()
                Log.shared.info("Total number of conversations: \(count)")
            } catch {
                Log.shared.info("Error fetching conversation count: \(error)")
            }
        }
    }
    
    //MARK: Private
    private func setupSubscriptions() {
        repo.didUpdateRepo
            .compactMap {[weak self] update -> Conversation? in
                guard case .updatedConversation(let updatedConversation) = update,
                      updatedConversation.id == self?.conversationSubject.value.id else { return nil }
                return updatedConversation
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] update in
                self?.conversationSubject.send(update)
            }
            .store(in: &subscriptions)
    }
    
    private func fetchInitialConversation() {
        Task {
            do {
                let fetchedConversation = try await repo.get(conversationId: conversationSubject.value.id)
                Log.shared.info("Fetching initial conversation: \(fetchedConversation)")
                DispatchQueue.main.async {
                    self.conversationSubject.send(fetchedConversation)
                }
            } catch {
//                Log.shared.info("Error fetching initial conversation: \(error)")
                DispatchQueue.main.async {
                    self.createNewConversation()
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
        conversationSubject.send(updatedConversation)
        
    }
    
    private func updateConversationLastMessage(message: Message) {
        var currentMessages = conversationSubject.value.messages
        if !currentMessages.isEmpty {
            currentMessages.removeLast()
        }
        currentMessages.append(message)
        let updatedConversation = Conversation(id: conversationSubject.value.id, messages: currentMessages)
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

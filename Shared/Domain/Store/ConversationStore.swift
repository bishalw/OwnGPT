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
        setupSubscriptions()
        fetchInitialConversation()
    }
    
    func sendMessage(string: String) {
        Task {
            initializeConversation(with: string)
            do {
                let history = conversation.getOpenApiHistory()
                print("Sending request with text: \(string) and history: \(history)")
                let responseStream = try await chatGPTAPI.sendMessageStream(text: string, history: history)
                print("Response stream received")
                try await processResponseStream(responseStream)
            } catch {
                print("Error in sendMessage: \(error)")
            }
        }
    }
    
    //MARK: Private
    private func setupSubscriptions() {
        repo.didUpdateRepo
            .sink { [weak self] update in
                guard case .updatedConversation(let updatedConversation) = update,
                      updatedConversation.id == self?.conversation.id else { return }
                // Update the conversation on the main thread
                DispatchQueue.main.async {
                    self?.conversation = updatedConversation
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchInitialConversation() {
        Task {
            do {
                let fetchedConversation = try await repo.get(conversationId: conversation.id)
                print("Fetching initial conversation: \(fetchedConversation)")
                DispatchQueue.main.async {
                    self.conversation = fetchedConversation
                }
            } catch {
                print("Error fetching initial conversation: \(error)")
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
        print("Processing response stream...")
        do {
            for try await messageContent in responseStream {
                print("Received chunk: \(messageContent)")
                fullResponse += messageContent
                let systemMessage = Message(id: UUID(), type: .system, content: .message(string: fullResponse), isStreaming: true)
                updateConversationLastMessage(message: systemMessage)
            }
            print("Final response: \(fullResponse)")
            finalizeConversation(with: fullResponse)
        } catch {
            print("Error processing response stream: \(error)")
        }
    }

    private func addConversation(message: Message) {
        var currentMessages = conversation.messages
        currentMessages.append(message)
        self.conversation = Conversation(id: conversation.id, messages: currentMessages)
        print("Added message to conversation: \(message)")
    }
    
    private func updateConversationLastMessage(message: Message) {
        var currentMessages = conversation.messages
        if !currentMessages.isEmpty {
            currentMessages.removeLast()
        }
        currentMessages.append(message)
        self.conversation = Conversation(id: conversation.id, messages: currentMessages)
        print("Updated last message in conversation: \(message)")
    }
    
    private func finalizeConversation(with content: String) {
        let finalSystemMessage = Message(id: UUID(),
                                         type: .system,
                                         content: .message(string: content),
                                         isStreaming: false)
        updateConversationLastMessage(message: finalSystemMessage)
        print("Finalized Message: \(finalSystemMessage)")
        repo.save(conversation: conversation)
    }
}

fileprivate extension Conversation {
    func getOpenApiHistory() -> [OpenAiModels.Message] {
        self.messages.map { $0.toOpenAiMessage }
    }
}

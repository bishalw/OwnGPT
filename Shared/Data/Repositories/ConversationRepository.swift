//
//  ConversationRepository.swift
//  OwnGpt
//
//  Created by Bishalw on 12/9/23.
//

import Foundation
import Combine

enum ConversationRepoUpdate {
    case updatedConversation(conversation: Conversation)
    case updatedConversations
}

protocol ConversationRepository {
    var didUpdateRepo: AnyPublisher<ConversationRepoUpdate, Never> { get }
    func save(conversations: [Conversation])
    func save(conversation: Conversation)
    func get() async throws -> [Conversation]
    func get(conversationId: UUID) async throws -> Conversation
    func getConversationCount() async throws -> Int
    func getFirstConversation() async throws -> Conversation?
}

class ConversationRepositoryImpl: ConversationRepository {
    
    
    //MARK: Private property
    private let _didUpdatePassthrough = PassthroughSubject<ConversationRepoUpdate, Never>()
    
    
    //MARK: Dependency
    private let conversationPersistenceService: ConversationPersistenceService
    
    init (conversationPersistenceService: ConversationPersistenceService) {
        self.conversationPersistenceService = conversationPersistenceService
    }
    //MARK: Public property
    var didUpdateRepo: AnyPublisher<ConversationRepoUpdate, Never> {
        return _didUpdatePassthrough.eraseToAnyPublisher()
    }
    
    // MARK: Public functions
    func getFirstConversation() async throws -> Conversation? {
        return try await conversationPersistenceService.getFirst()
    }
    
    func save(conversations: [Conversation]) {
        Task {
            do {
                for conversation in conversations {
                    try await conversationPersistenceService.add(conversation)
                }
                _didUpdatePassthrough.send(.updatedConversations)
            } catch {
                Log.shared.logger.error("Error saving conversations: \(error)")
            }
        }
    }
    
    func save(conversation: Conversation) {
        Task {
            do {
                try await conversationPersistenceService.add(conversation)
                Log.shared.logger.debug("Saved conversation: \(conversation.id)")
                _didUpdatePassthrough.send(.updatedConversation(conversation: conversation))
            } catch {
                Log.shared.logger.error("Error saving conversation: \(error)")
            }
        }
    }
    
    func get() async throws -> [Conversation] {
        var conversations = try await conversationPersistenceService.get()
        conversations.reverse()
        return conversations
    }
    
    func get(conversationId: UUID) async throws -> Conversation {
        let conversation = try await conversationPersistenceService.get(id: conversationId)
        return conversation
    }
    
    func getConversationCount() async throws -> Int {
        return try await conversationPersistenceService.getCount()
    }
}

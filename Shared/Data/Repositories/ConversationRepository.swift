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
    
    private let conversationPersistenceService: ConversationPersistenceService
    
    private let _didUpdatePassthrough = PassthroughSubject<ConversationRepoUpdate, Never>()
    
    init (conversationPersistenceService: ConversationPersistenceService) {
        self.conversationPersistenceService = conversationPersistenceService
    }
    
    var didUpdateRepo: AnyPublisher<ConversationRepoUpdate, Never> {
        return _didUpdatePassthrough.eraseToAnyPublisher()
    }
    func getFirstConversation() async throws -> Conversation? {
        return try await conversationPersistenceService.getFirst()
    }
    func save(conversations: [Conversation]) {
        Task {
            for conversation in conversations {
                try await conversationPersistenceService.add(conversation)
            }
            _didUpdatePassthrough.send(.updatedConversations)
        }
    }
    
    func save(conversation: Conversation) {
        Task {
            try await conversationPersistenceService.add(conversation)
            _didUpdatePassthrough.send(.updatedConversation(conversation: conversation))
        }
    }
    
    
    func get() async throws -> [Conversation] {
        let conversations =  try await conversationPersistenceService.get()
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

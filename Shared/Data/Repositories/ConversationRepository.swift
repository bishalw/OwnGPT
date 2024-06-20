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
    
    func save(conversations: [Conversation]) {
        for conversation in conversations {
            conversationPersistenceService.add(conversation)
        }
        _didUpdatePassthrough.send(.updatedConversations)
    }
    
    func save(conversation: Conversation) {
        conversationPersistenceService.add(conversation)
        _didUpdatePassthrough.send(.updatedConversation(conversation: conversation))
    }
    
    func get() async throws -> [Conversation] {
        let conversations =  try await conversationPersistenceService.get()
        return conversations
    }
    
    func get(conversationId: UUID) async throws -> Conversation {
        let conversation = try await conversationPersistenceService.get(id: conversationId)
        return conversation
    }
}

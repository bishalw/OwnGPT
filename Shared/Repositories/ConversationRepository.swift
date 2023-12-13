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
    case updatedConvsersations
}

protocol ConversationRepository {
    var didUpdateRepo: AnyPublisher<ConversationRepoUpdate, Never> { get }
    func save(conversations: [Conversation])
    func save(conversation: Conversation)
    func get() async throws -> [Conversation]
    func get(converstaionId: String) async throws -> Conversation
}

// TODO: - 
class ConversationRepositoryImpl: ConversationRepository {
    
    private let conversationStore: ConversationStore
    private let conversationsStore: ConversationsStore
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
        _didUpdatePassthrough.send(.updatedConvsersations)
    }
    
    func save(conversation: Conversation) {
        conversationPersistenceService.add(conversation)
        _didUpdatePassthrough.send(.updatedConversation(conversation: conversation))
    }
    
    func get() async throws -> [Conversation] {
        let conversations =  try await conversationPersistenceService.getConversations()
        return conversations
    }
    
    func get(converstaionId: String) async throws -> Conversation {
        let conversation = try await conversationPersistenceService.get()
        return conversation
    }
}

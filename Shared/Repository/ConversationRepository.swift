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
    func get() -> [Conversation]
    func get(converstaionId: String) -> Conversation
}

// TODO: - 
class ConversationRepositoryImpl: ConversationRepository {
    private let _didUpdatePassthrough = PassthroughSubject<ConversationRepoUpdate, Never>()
    
    var didUpdateRepo: AnyPublisher<ConversationRepoUpdate, Never> {
        return _didUpdatePassthrough.eraseToAnyPublisher()
    }
    
    func save(conversations: [Conversation]) {
        // Implement
        _didUpdatePassthrough.send(.updatedConvsersations)
    }
    
    func save(conversation: Conversation) {
        // Implement
        _didUpdatePassthrough.send(.updatedConversation(conversation: conversation))
    }
    
    func get() -> [Conversation] {
        return []
    }
    
    func get(converstaionId: String) -> Conversation {
        return .init(id: .init(), messages: [])
    }
}

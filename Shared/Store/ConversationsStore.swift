//
//  ConversationsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 12/10/23.
//

import Foundation
import Combine

class ConversationsStore {
    private var subscription = Set<AnyCancellable>()
    @Published var conversations: [Conversation]
    
    init(repo: ConversationRepository) {
        self.conversations = repo.get()
        
        repo.didUpdateRepo.sink { someCase in
            switch someCase {
            case .updatedConvsersations, .updatedConversation:
                self.conversations = repo.get()
            }
        }
        .store(in: &subscription)
    }
}

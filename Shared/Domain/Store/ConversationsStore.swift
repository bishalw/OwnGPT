//
//  ConversationsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 12/10/23.
//

import Foundation
import Combine

class ConversationsStore {
    private var subscriptions = Set<AnyCancellable>()
    @Published var conversations: [Conversation] = []
    private let repo: ConversationRepository
    
    init(repo: ConversationRepository) {
        self.repo = repo
        // Subscribe to repository updates
        repo.didUpdateRepo.sink { [weak self] update in
            self?.loadConversations()
        }
        .store(in: &subscriptions)
        
        // Load initial conversations
        loadConversations()
    }
    
    private func loadConversations() {
        Log.shared.logger.info("Loading Conversations")
        Task { [weak self] in
            do {
                let loadedConversations = try await self?.repo.get()
                self?.conversations = loadedConversations ?? []
            } catch {
                Log.shared.logger.info("Failed to load conversations: \(error)")
            }
        }
    }
}

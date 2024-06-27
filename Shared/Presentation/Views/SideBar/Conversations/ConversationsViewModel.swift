//
//  ChatsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 8/6/23.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ConversationsViewModel: ObservableObject {
    
    @Published var conversations: [Conversation] = []
    private var conversationsStore: ConversationsStore
    private var cancellables = Set<AnyCancellable>()
    
    init(conversationsStore: ConversationsStore) {
        self.conversationsStore = conversationsStore
        setUpBindings()
    }
    
    func setUpBindings() {
        conversationsStore.$conversations
            .receive(on: RunLoop.main)
            .sink { [weak self] conversations in
                self?.conversations = conversations
//                Log.shared.info("\(conversations)")
            }
            .store(in: &cancellables)
    }
}

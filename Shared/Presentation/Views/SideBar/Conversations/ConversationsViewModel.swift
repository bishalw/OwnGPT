//
//  ChatsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 8/6/23.
//

import Foundation
import SwiftUI
import Combine

protocol ConversationsViewModelSharedProvider {
    var selectedConversationPublisher: Published<Conversation?> { get }
}

@MainActor
final class ConversationsViewModel: ObservableObject {
    
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation?
    private var conversationsStore: ConversationsStore
    private var cancellables = Set<AnyCancellable>()
    
    init(conversationsStore: ConversationsStore, conversationsViewModelSharedProvider: ConversationsViewModelSharedProvider) {
        self.conversationsStore = conversationsStore
        self._selectedConversation = conversationsViewModelSharedProvider.selectedConversationPublisher
        setUpBindings()
    }
    func setUpBindings() {
        conversationsStore.$conversations
            .receive(on: RunLoop.main)
            .sink { [weak self] conversations in
                self?.conversations = conversations

            }
            .store(in: &cancellables)
    }
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
    }
}

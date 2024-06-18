//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 12/8/23.
//

import Foundation
import SwiftUI
import Combine


class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    var store: ConversationStore
    @Published var inputMessage: String = ""
    private var cancellables: Set<AnyCancellable> = .init()
    init(store: ConversationStore) {
        self.store = store
        addSubscribers()
    }
    
    func addSubscribers() {
        store.$conversation
            .map {$0.messages}
            .receive(on: RunLoop.main)
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
        
    }

    @MainActor
    func sendMessage() {
        let trimmedText = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            store.sendMessage(string: trimmedText)
            inputMessage = ""
        }
    }
}

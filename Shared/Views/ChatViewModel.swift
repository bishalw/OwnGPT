//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 12/8/23.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
     let store: ConversationStore
    @Published var inputMessage: String = ""
    private var cancellables: Set<AnyCancellable> = .init()
    init(store: ConversationStore) {
        self.store = store
        store.$conversation
            .map {$0.messages}
            .receive(on: RunLoop.main)
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
    }
    
    func sendMessage() async  {
        let trimmedText = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            try? await store.sendMessage(string: trimmedText)
            inputMessage = ""
        }
    }
}

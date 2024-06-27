//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine

@MainActor
final class ConversationViewModel: ObservableObject {
    
    @Published var isSendButtonDisabled: Bool = false
    @Published var showPlaceholder: Bool = true
    @Published var messages: [Message] = []
    var conversation: Conversation
    
    @Published var inputMessage: String = "" {
        didSet {
            isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    var messageIsStreaming: Bool {
            messages.contains(where: { $0.isStreaming })
    }
    private func updatePlaceholderVisibility() {
            showPlaceholder = messages.isEmpty
        }
    private var cancellables = Set<AnyCancellable>()
    private var store: ConversationStore
    
    init(store: ConversationStore, conversation: Conversation) {
        self.store = store
        self.conversation = conversation
        setupBindings()
        updatePlaceholderVisibility()
    }
    
    private func setupBindings(){
        store.conversation
            .map { $0.messages }
            .receive(on: RunLoop.main)
            .sink { [weak self] messages in
                self?.messages = messages
                self?.updatePlaceholderVisibility()
            }
            .store(in: &cancellables)
    }

    func sendTapped()  {
        updatePlaceholderVisibility()
        isSendButtonDisabled.toggle()
        let text = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputMessage = ""
        store.sendMessage(string:text)
    }
    func createNewConversation() {
        store.createNewConversation()
    }
    func retry(message: Message)   {
        if case let .message(string: text) = message.content {
            store.sendMessage(string: text)
        }
    }
    
    func send(text: String)  {
        store.sendMessage(string: text)
    }
    
    func printTotalConversations() {
        store.printConversationCount()
    }
    
    func loadFirstConversation() {
        Task {
            do {
                if let loadedConversation = try await store.loadFirstConversation() {
                    await MainActor.run {
                        self.conversation = loadedConversation
                        self.messages = loadedConversation.messages
                    }
                } else {
                    Log.shared.info("No conversations found")
                }
            } catch {
                Log.shared.error("Error loading first conversation: \(error)")
    
            }
        }
    }
}

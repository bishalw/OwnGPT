//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine
@MainActor
final class ConversationViewModel: ObservableObject {
    @Published  var isSendButtonDisabled = true
    @Published private(set) var showPlaceholder = true
    @Published private(set) var messages: [Message] = []
    @Published var inputMessage = "" {
        didSet { updateSendButtonState() }
    }
    
    private let store: ConversationStore
    private var conversation: Conversation
    private var cancellables = Set<AnyCancellable>()
    
    var messageIsStreaming: Bool {
        messages.contains { $0.isStreaming }
    }
    
    init(store: ConversationStore, conversation: Conversation) {
        self.store = store
        self.conversation = conversation
        setupBindings()
        updatePlaceholderVisibility()
    }
    
    func sendTapped() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSendButtonDisabled.toggle()
        send(text: inputMessage)
        inputMessage = ""
    }
    
    func createNewConversation() {
        store.createNewConversation()
    }
    
    func retry(message: Message) {
        if case let .message(string: text) = message.content {
            send(text: text)
        }
    }
    
    func send(text: String) {
        store.sendMessage(string: text)
    }
    
    func printTotalConversations() {
        store.printConversationCount()
    }
    
    func loadFirstConversation() async {
        do {
            if let loadedConversation = try await store.loadFirstConversation() {
                self.conversation = loadedConversation
                self.messages = loadedConversation.messages
            } else {
                Log.shared.info("No conversations found")
            }
        } catch {
            Log.shared.error("Error loading first conversation: \(error)")
        }
    }
    
    private func setupBindings() {
        store.conversation
            .map(\.messages)
            .receive(on: RunLoop.main)
            .sink { [weak self] messages in
                self?.messages = messages
                self?.updatePlaceholderVisibility()
            }
            .store(in: &cancellables)
    }
    
    private func updatePlaceholderVisibility() {
        showPlaceholder = messages.isEmpty
    }
    
    private func updateSendButtonState() {
        isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

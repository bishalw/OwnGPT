//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import Combine

protocol ConversationViewModelSharedProvider {
    var selectedConversationPublisher: Published<Conversation?> { get }
}

@MainActor
final class ConversationViewModel: ObservableObject {
    @Published var isSendButtonDisabled = true
    @Published private(set) var showPlaceholder = true
    @Published private(set) var messages: [Message] = []
    @Published var selectedConversation: Conversation?
    @Published var inputMessage = "" {
        didSet { updateSendButtonState() }
    }
    
    private let store: ConversationStore
    private var cancellables = Set<AnyCancellable>()
    
    var messageIsStreaming: Bool {
        messages.contains { $0.isStreaming }
    }
    
    private(set) var conversation: Conversation
    
    init(store: ConversationStore, conversationViewModelSharedProvider: ConversationViewModelSharedProvider) {
        self.store = store
        self.conversation = store.createNewConversation()
        self._selectedConversation = conversationViewModelSharedProvider.selectedConversationPublisher
        setupBindings()
        updatePlaceholderVisibility()
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
        
        $selectedConversation
            .compactMap { $0 }
            .sink { [weak self] conversation in
                self?.updateSelectedConversation(conversation)
            }
            .store(in: &cancellables)
    }

    private func updateSelectedConversation(_ conversation: Conversation) {
        self.conversation = conversation
        self.messages = conversation.messages
        self.updatePlaceholderVisibility()
        self.store.updateWithSelectedConversation(conversation)
    }
    
    func sendTapped() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSendButtonDisabled.toggle()
        send(text: inputMessage)
        inputMessage = ""
    }
    
    func createNewConversation() {
        let newConversation = store.createNewConversation()
        self.selectedConversation = newConversation
        self.store.updateWithSelectedConversation(newConversation)
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
    
    
    private func updatePlaceholderVisibility() {
        showPlaceholder = messages.isEmpty
    }
    
    private func updateSendButtonState() {
        isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

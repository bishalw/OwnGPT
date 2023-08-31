//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.

import Foundation
import SwiftUI

class ChatScreenViewModel: ObservableObject  {
    
    @Published var isStreaming: Bool = false
    @Published private var conversation: Conversation
    @Published var isSendButtonDisabled: Bool = true
    @Published var isTextFieldFocused = false
    @Environment(\.managedObjectContext) var context
    
    var messages: [Message] {
        // fetchMessagesFromCoreData()
        return conversation.messages
    }
    
    var updateConversation: (Conversation) -> ()
    
    @Published var inputMessage: String = "" {
        didSet {
            isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var retryCallback: (Message) -> ()
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI,history: [OpenAiModels.Message]? = nil,conversation: Conversation, retryCallback: @escaping (Message) -> (), updateConversation: @escaping (Conversation) -> ()) {
        self.retryCallback = retryCallback
        self.api = api
        self.conversation = /*self.fetchConversationFromCoreData() ?? conversation*/ conversation
        self.updateConversation = updateConversation
        
        if let unwrappedHistory = history  {
            api.historyList = unwrappedHistory
        }
    }
    
    func fetchConversationFromCoreData() /*-> Conversation?*/ {
        
    }
    
    func saveConversationToCoreData() {
        
    }
    
    
    @MainActor
    func sendTapped() async {
        isTextFieldFocused = true
        isSendButtonDisabled = true
        let text = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputMessage = ""
        await send(text: text)
        updateConversation(conversation)
        // updateConversationInCoreData(conversation) 
        saveConversationToCoreData()
    }

    @MainActor
    func retry(message: Message) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id}) else {
            return
        }
        removeMessage(at: index)
        if case let .message(string: text) = message.content {
            await send(text: text)
        }
    }
    private func removeMessage(at index: Int) {
        conversation.messages.remove(at: index)
    }
    @MainActor
    func clearMessages() {
        api.deleteHistoryList()
        withAnimation {
            conversation.messages.removeAll()
        }
        updateConversation(conversation)
    }
    
    
    @MainActor
    private func send(text: String) async {
        let userMessage = Message(id: UUID(), type: .user, content: .message(string: text), isStreaming: true)
//        Task {
//            conversation.messages.append(userMessage)
//        }
        

        var responseText = ""
        do {
            let stream = try await api.sendMessageStream(text: text)
            var responseMessage: Message? = nil
            for try await part in stream {
                responseText += part
                if let currentResponseMessage = responseMessage {
                    // If there is already a system message, we update it
                    if let index = messages.firstIndex(where: { $0.id == currentResponseMessage.id }) {
                        let updatedMessage = Message(id: currentResponseMessage.id, type: .system, content: .message(string: responseText.trimmingCharacters(in: .whitespacesAndNewlines)), isStreaming: true)
                        conversation.messages[index] = updatedMessage
                    }
                } else {
                    // If there is no system message yet, we create one
                    responseMessage = Message(id: UUID(), type: .system, content: .message(string: responseText.trimmingCharacters(in: .whitespacesAndNewlines)), isStreaming: true)
                    if let responseMessage = responseMessage {
                        conversation.messages.append(responseMessage)
                    }
                }
            }

            // When the stream is finished, update the system message to set isStreaming to false
            if let currentResponseMessage = responseMessage, let index = messages.firstIndex(where: { $0.id == currentResponseMessage.id }) {
                let finishedMessage = Message(id: currentResponseMessage.id, type: .system, content: .message(string: responseText.trimmingCharacters(in: .whitespacesAndNewlines)), isStreaming: false)
                conversation.messages[index] = finishedMessage
            }
        } catch {
            let errorRow = Message(id: UUID(), type: .system, content: .error(error: error), isStreaming: false)
            conversation.messages.append(errorRow)
            // Update the conversation in the ChatsViewModel
            updateConversation(conversation)
            return
        }
    }
}

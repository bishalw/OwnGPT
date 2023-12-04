//
//  ConversationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/31/23.
//

import Foundation

class ConversationsRepository {
    
    let api: ChatGPTAPI
    let coreDataService: ConversationCoreDataService
    
    init(api: ChatGPTAPI, coreDataService: ConversationCoreDataService) {
        self.api = api
        self.coreDataService = coreDataService
    }
    

}

class ConversationStore: ObservableObject {
    
    @Published var conversation: Conversation
    
    var messages: [Message] {
        return conversation.messages
    }
    var historyList = [OpenAiModels.Message]()
    
    let api: ChatGPTAPI
    let coreDataService: ConversationCoreDataService
    
    init(conversation: Conversation, api: ChatGPTAPI, coreDataService: ConversationCoreDataService) {
        self.conversation = conversation
        self.api = api
        self.coreDataService = coreDataService
    }
    func loadConversations() {
        Task {
            let conversations = await coreDataService.get()
            if let first = conversations.first {
                DispatchQueue.main.async {
                    self.conversation = first
                }
            }
        }
    }
    
     func send(text: String) async {
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
//            updateConversation(conversation)
            return
        }
    }
    
}

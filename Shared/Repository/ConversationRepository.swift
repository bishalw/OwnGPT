//
//  ConversationRepository.swift
//  OwnGpt
//
//  Created by Bishalw on 12/9/23.
//

import Foundation
class ConversationsRepository {
    
    @Published  var historyList: [OpenAiModels.Message] = []
    let api: ChatGPTAPI
    
    init(api: ChatGPTAPI ) {
        self.api = api
    }
    
    func sendMessage(_ text: String) async throws -> String {
        // Adding user message to the local history
        let userMessage = OpenAiModels.Message(role: "user", content: text)
        addMessage(userMessage)
        print("Updated historyList: \(historyList)")
        
        do {
            let responseStream = try await api.sendMessageStream(text: text, history: historyList)
            var fullResponse = ""
            for try await messageContent in responseStream {
                fullResponse += messageContent
                
                
                let apiMessage = OpenAiModels.Message(role: "assistant", content: messageContent)
                addMessage(apiMessage)
                print("Received and added response to historyList: \(apiMessage)")
            }
            print("Updated historyList after server response: \(historyList)")
            return fullResponse
        } catch {
            print("Error in sendMessage: \(error)")
            throw error
        }
    }
    func getHistoryList() -> [OpenAiModels.Message] {
        return historyList
    }
    
    func addMessage(_ message: OpenAiModels.Message) {
        historyList.append(message)
        
    }
    
    func clearHistory() {
        historyList.removeAll()
    }
    
    private func generateMessages(from text: String) -> [OpenAiModels.Message] {
        var messages = historyList + [OpenAiModels.Message(role: "user", content: text)]
        
        if messages.contentCount > (4000 * 4) {
            messages = Array(messages.dropFirst())
        }
        return messages
    }
}

//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import Foundation

class ChatViewModel: ObservableObject  {
    
    @Published var isInteractingWithOwnGPT: Bool = false
    @Published var messages: [ChatRow] = []
    @Published var inputMessage: String = ""
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI) {
        self.api = api
    }
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    func retry(message: ChatRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id}) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.sendText)
    }
    
    
    @MainActor
    private func send(text: String) async {
        isInteractingWithOwnGPT = true
        var streamText = ""
        var chatRow = ChatRow(isInteractingWithOwnGPT: true,
                              UserIcon: "person.crop.circle",
                              sendText: text,
                              responseGPTIcon: "brain",
                              responseText: streamText,
                              responseError: nil)
        self.messages.append(chatRow)
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                chatRow.responseText = streamText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.messages[self.messages.count-1] = chatRow
            }
        } catch  {
            chatRow.responseError = error.localizedDescription
        }
        chatRow.isInteractingWithOwnGPT = false
        self.messages[self.messages.count - 1] = chatRow
        isInteractingWithOwnGPT = false
    }
}
extension ChatViewModel  {
   
}

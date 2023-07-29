//
//  ChatViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import Foundation
import SwiftUI

class ChatScreenViewModel: ObservableObject  {
    
    @Published var isInteractingWithOwnGPT: Bool = false
    @Published var messages: [ChatRow] = []
    @Published var isSendButtonDisabled: Bool = false
    @Published var textFieldUUID: UUID = UUID()
    @Published var isTextFieldFocused = false
    
    @Published var inputMessage: String = "" {
        didSet {
            isSendButtonDisabled = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var retryCallback: (ChatRow) -> ()
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI, retryCallback: @escaping (ChatRow) -> ()) {
        self.retryCallback = retryCallback
        self.api = api
    }
    
    @MainActor
    func sendTapped() async {
        isTextFieldFocused = true
        isSendButtonDisabled = true
        let text = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { return }
            inputMessage = ""
            isSendButtonDisabled = false
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
    func clearMessages() {
        api.deleteHistoryList()
        withAnimation { [weak self] in
             self?.messages = []
        }
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
        messages.append(chatRow)
        
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
        messages[self.messages.count - 1] = chatRow
        isInteractingWithOwnGPT = false
    }
}
extension ChatScreenViewModel  {
   
}

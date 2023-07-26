//
//  OwnGptWatchAppApp.swift
//  OwnGptWatchApp Watch App
//
//  Created by Bishalw on 7/24/23.
//

import SwiftUI

@main
struct OwnGptWatchApp_Watch_AppApp: App {
    
    @StateObject var chatScreenViewModel = ChatScreenViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey), retryCallback: { _ in })
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatScreenView().environmentObject(chatScreenViewModel)
                    .navigationBarTitleDisplayMode(.inline)
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .toolbar {
                        ToolbarItemGroup {
                            HStack {
                                Button("Send") {
                                    self.presentInputController(withSuggestions: []) { result in
                                        Task { @MainActor in
                                            guard !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                                return
                                            }
                                            chatScreenViewModel.inputMessage = result.trimmingCharacters(in: .whitespacesAndNewlines)
                                            await chatScreenViewModel.sendTapped()
                                        }
                                    }
                                }.tint(.teal)
                                Button("Clear", role: .destructive) {
                                    chatScreenViewModel.clearMessages()
                                }.tint(.red)
                                    .disabled(chatScreenViewModel.isInteractingWithOwnGPT || chatScreenViewModel.messages.isEmpty)
                            }
                        }
                    }
            }
            
        }
    }
}

extension App {
    typealias StringCompletion = (String) -> Void

    func presentInputController(withSuggestions suggestions: [String], completion: @escaping StringCompletion) {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: suggestions, allowedInputMode: .plain, completion: { result in
                guard let  result = result as? [String], let firstElement = result.first else {
                    return
                }
                completion(firstElement)
            })
    }
}

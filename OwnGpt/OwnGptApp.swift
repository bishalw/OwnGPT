//
//  OwnGptApp.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

@main
struct OwnGptApp: App {
    
    let vm = ChatViewModel(store: ConversationStore(chatGPTAPI:ChatGPTAPIServiceImpl(networkService: NetworkServiceImpl(), apiKey: Constants.apiKey), repo: ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: PersistenceController()))))
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatView(vm: vm)
            }
        }
    }
}

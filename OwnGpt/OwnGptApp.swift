//
//  OwnGptApp.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

@main
struct OwnGptApp: App {
    
    @StateObject var core: Core = Core()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ConversationView(conversationViewModel: ConversationViewModel(store: ConversationStore(chatGPTAPI: ChatGPTAPIServiceImpl(networkService: NetworkServiceImpl(), apiKey: Constants.apiKey), repo: ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: PersistenceController())))))
            }
        }
    }
}

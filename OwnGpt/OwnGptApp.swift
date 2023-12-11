//
//  OwnGptApp.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

@main
struct OwnGptApp: App {
//    var chatScreenViewModel = ChatScreenViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey),  retryCallback: { _ in })
//    @StateObject var chatsViewModel = ChatsViewModel()

//    let persistenceController = PersistenceController() // intialize
//    var store = ConversationStore(conversationRepository: ConversationsRepository(api: ChatGPTAPI(apiKey: Constants.apiKey)))
//    @StateObject var store = ConversationStore(conversationRepository: ConversationsRepository(api: ChatGPTAPI(apiKey: Constants.apiKey)))
   
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                ChatScreenView(chatScreenViewModel: chatScreenViewModel)
//                ConversationsView(conversationsViewModel: ConversationsViewModel(/*conversationsCoreDataService: .init(manager: persistenceController))*/))
                ChatView(vm: ChatViewModel(store: ConversationStore(chatGPTAPI: ChatGPTAPI(apiKey: Constants.apiKey), conversation: nil, repo: ConversationRepositoryImpl())))
//                    .environmentObject(store)
//                    .environment(\.managedObjectContext, persistenceController.context)
                
                // ideally .envionmentObject(coreDataService)
            }

            
        }
    }
}

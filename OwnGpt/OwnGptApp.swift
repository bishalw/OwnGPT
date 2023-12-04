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

    let persistenceController = PersistenceController()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                ChatScreenView(chatScreenViewModel: chatScreenViewModel)
                ConversationsView(conversationsViewModel: ConversationsViewModel(conversationsCoreDataService: .init(manager: persistenceController)))
                    .environment(\.managedObjectContext, persistenceController.context)
            }

            
        }
    }
}


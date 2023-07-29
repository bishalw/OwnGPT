//
//  OwnGptWatchAppApp.swift
//  OwnGptWatchApp Watch App
//
//  Created by Bishalw on 7/24/23.
//

import SwiftUI

@main
struct OwnGptWatchApp_Watch_AppApp: App {
    
    var chatScreenViewModel = ChatScreenViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey), retryCallback: { _ in })
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WatchOSView( chatScreenViewModel: chatScreenViewModel)
                    }
                    
                }
            }
}

extension App {
   
}

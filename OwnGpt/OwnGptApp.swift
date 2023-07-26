//
//  OwnGptApp.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

@main
struct OwnGptApp: App {
    @StateObject var chatScreenViewModel = ChatScreenViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey), retryCallback: { _ in })

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatScreenView()
                    .environmentObject(chatScreenViewModel)
            }
        }
    }
}


//
//  OwnGptApp.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

@main
struct OwnGptApp: App {
    @StateObject var core = Core()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ConversationsView(conversationsViewModel: ConversationsViewModel(store: ConversationsStore(repo: core.conversationRepository)))
            }
        }
    }
}

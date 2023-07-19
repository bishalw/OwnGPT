//
//  OwnGptApp.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

@main
struct OwnGptApp: App {
    @StateObject var vm =  ChatViewModel(api: ChatGPTAPI(apiKey: Constants.apiKey))
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatScreenView().environmentObject(vm)
            }
           
        }
    }
}

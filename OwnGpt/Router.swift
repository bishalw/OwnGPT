//
//  Router.swift
//  OwnGpt
//
//  Created by Bishalw on 12/13/23.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    enum Route: Hashable {
        case conversation
    }
    @ViewBuilder
    func view (for route: Route) -> some View {
//        switch route {
//        case .conversation
//            ConversationView(conversationViewModel: ConversationViewModel(store: ConversationStore(chatGPTAPI: core.chatGPTAPIService, conversation: <#T##Conversation?#>, repo: <#T##ConversationRepository#>)))
//        }
    }
}

extension Router {
    func navigate(to destination: Route) {
        path.append(destination)
    }
    
    func navigate(back destination: Route) {
        path.removeLast()
    }
    func navigateToRoot(){
        path.removeLast(path.count)
    }
}

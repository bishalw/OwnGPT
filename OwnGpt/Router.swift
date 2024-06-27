//
//  Router.swift
//  OwnGpt
//
//

import Foundation
import SwiftUI

// MARK: WIP (Work in progress)
class Router: ObservableObject {
    
    enum Route: Hashable {
        case MainView
        case ConversationView(String)
        case SettingsView
    }
    
    
    @Published var path: NavigationPath = NavigationPath()

    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .MainView:
            EmptyView()
        case .ConversationView(_):
            EmptyView()
        case .SettingsView:
            EmptyView()
        }
    }
    
    
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}


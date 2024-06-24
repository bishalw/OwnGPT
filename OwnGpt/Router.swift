//
//  Router.swift
//  OwnGpt
//
//  Created by Bishalw on 12/13/23.
//

import Foundation
import SwiftUI


class Router: ObservableObject {
    
    enum Route: Hashable {
        case viewA
        case viewB(String)
        case viewC
    }
    
    
    @Published var path: NavigationPath = NavigationPath()
    
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .viewA:
            EmptyView()
        case .viewB(let str):
            EmptyView()
        case .viewC:
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


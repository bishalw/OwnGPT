//
//  RootView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/22/24.
//

import SwiftUI
enum Envrionment {
    case showOnboarding
    case showMain
    case onlyShowOnboarding
}
struct RootView<VM: RootViewModel>: View {
    @EnvironmentObject var core: Core
    @StateObject var vm: VM
    @State var environment: Envrionment = .showMain
    
    var body: some View {
        switch environment {
        case .showOnboarding:
            if vm.hasUserOnboarded {
                MainView()
            } else {
                OnboardingView {
                    vm.updateOnBoarded()
                }
            }
        case .showMain:
            MainView()
        case .onlyShowOnboarding:
            OnboardingView {
                vm.updateOnBoarded()
            }
        }
        
    }
}

//#Preview {
//    RootView()
//}

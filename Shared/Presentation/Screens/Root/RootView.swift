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
    @State var environment: Envrionment = .showOnboarding
    
    var body: some View {
        switch environment {
        case .showOnboarding:
            if vm.hasUserOnboarded {
                MainView(mainViewModel: MainViewModel())
            } else {
                OnboardingView {
                    vm.updateOnBoarded()
                }
            }
        case .showMain:
            MainView( mainViewModel : MainViewModel())
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

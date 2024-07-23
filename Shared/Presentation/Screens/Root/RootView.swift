//
//  RootView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/22/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var core: Core
    @StateObject var vm: RootViewModel
    
    var body: some View {
        if vm.hasOnboarded {
            MainView(mainViewModel: MainViewModel())
        } else {
            OnboardingView {
                vm.updateOnboarded()
            }
        }
    }
}

//#Preview {
//    RootView()
//}

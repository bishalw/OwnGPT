//
//  OnboardingView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import SwiftUI

struct OnboardingView: View {
    var didOnBoard: () -> Void
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Configure your default model setting")
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .font(.title3)
                    Spacer()
                }
                ConfigurationView(vm: OpenAIConfigViewModelImpl(configStore: ConfigurationStoreImpl()) {
                    didOnBoard()
                })
            }
            .navigationTitle("Welcome ")
        }
    }
}


#Preview {
    OnboardingView{}
}

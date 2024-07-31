//
//  SettingsView2.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import SwiftUI

struct ServiceSelectorView: View {
    @EnvironmentObject var core: Core
    @State private var provider: ServiceKey = .openAIAPIKey
    var didOnboard: () -> Void = {}
    

    var body: some View {
        VStack {
            serviceSelectorPicker
            ConfigurationView(openAIVM: OpenAIConfigurationViewModelImpl(openAIConfigStore: core.openAIConfigStore), anthropicVM: AnthropicConfigurationViewModelImpl(anthropicConfigStore: core.anthropicConfigStore), selectedProvider: $provider)
        }
    }
    
    @ViewBuilder
    private var serviceSelectorPicker: some View {
        Picker("Service", selection: $provider) {
            ForEach(ServiceKey.allCases, id: \.self) { key in
                Text(key.displayName).tag(key)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

}

struct ConfigurationView<VM1: OpenAIConfigurationViewModel, VM2: AnthropicConfigurationViewModel>: View {
    @StateObject var openAIVM: VM1
    @StateObject var anthropicVM: VM2
    @Binding var selectedProvider: ServiceKey
    
    var body: some View {
        Group {
            switch selectedProvider {
            case .openAIAPIKey:
                OpenAIConfigurationView(vm: openAIVM)
            case .anthropicAPIKey:
                AnthropicConfigurationView(vm: anthropicVM)
            }
        }
    }
}






#Preview {
    ServiceSelectorView()
}

//
//  SettingsView2.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import SwiftUI

struct ServiceSelectorView: View {
    
    @EnvironmentObject var core: Core
    @State private var provider: serviceProvider = .openAI
    
    var didOnboard: () -> Void = {}
    

    var body: some View {
        VStack {
            serviceSelectorPicker
            ConfigurationView(openAIVM: openAIVMFactory,
                              anthropicVM: anthropicVMFactory,
                              selectedProvider: $provider)
        }
    }
    
    private var openAIVMFactory: OpenAIConfigurationViewModelImpl {
        return OpenAIConfigurationViewModelImpl(openAIConfigStore: core.openAIConfigStore)
    }
    
    private var anthropicVMFactory:AnthropicConfigurationViewModelImpl {
        return AnthropicConfigurationViewModelImpl(anthropicConfigStore: core.anthropicConfigStore)
    }
    
    
    @ViewBuilder
    private var serviceSelectorPicker: some View {
        Picker("Service", selection: $provider) {
            ForEach(serviceProvider.allCases, id: \.self) { key in
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
    @Binding var selectedProvider: serviceProvider
    
    var body: some View {
        Group {
            switch selectedProvider {
            case .openAI:
                OpenAIConfigurationView(vm: openAIVM)
                
            case .anthropic:
                AnthropicConfigurationView(vm: anthropicVM)
            }
        }
    }
}

#Preview {
    ServiceSelectorView()
}

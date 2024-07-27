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
            ConfigurationView(openAIVM: OpenAIConfigViewModelImpl(), anthropicVM: AnthropicConfigurationViewModelImpl(), selectedProvider: $provider)
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

struct OpenAIConfigurationView<VM: OpenAIConfigurationViewModel>: View {
    
    @ObservedObject var vm: VM
    
    var body: some View {
        Form {
            Section("OpenAI Model Settings") {
                SecureField("API Key", text: $vm.apiKey)
                    .textContentType(.password)
                
                Picker("Model", selection: $vm.selectedModel) {
                    ForEach(OpenAIModelType.allCases, id: \.self) { model in
                        Text(model.rawValue).tag(model)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Temperature: \(vm.temperature, specifier: "%.2f")")
                    Slider(value: $vm.temperature, in: 0...1, step: 0.1)
                }
                
                Stepper("Context Window: \(vm.contextWindowSize)", value: $vm.contextWindowSize, in: 1...20)
                
                Button("Save Changes") {
                    vm.save()
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

struct AnthropicConfigurationView<VM: AnthropicConfigurationViewModel>: View {
    @ObservedObject var vm: VM
    
    var body: some View {
        Form {
            Section("Anthropic Model Settings") {
                SecureField("API Key", text: $vm.apiKey)
                    .textContentType(.password)
                
                Picker("Model", selection: $vm.selectedModel) {
                    ForEach(AnthropicModelType.allCases, id: \.self) { model in
                        Text(model.rawValue).tag(model)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Temperature: \(vm.temperature, specifier: "%.2f")")
                    Slider(value: $vm.temperature, in: 0...1, step: 0.1)
                }
                
                Stepper("Context Window: \(vm.contextWindowSize)", value: $vm.contextWindowSize, in: 1...20)
                
                Button("Save Changes") {
                    vm.save()
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

enum ServiceKey: String, CaseIterable, Codable{
    case openAIAPIKey
    case anthropicAPIKey
    
    var displayName: String {
        switch self {
            
        case .openAIAPIKey: 
            return "OpenAI"
        case .anthropicAPIKey:
            return "Anthropic"
        }
    }
    var keyName: String {
        switch self {
            
        case .openAIAPIKey:
            return "com.OwnGPT.ServiceKey.OpenAI"
        case .anthropicAPIKey:
            return "com.OwnGPT.ServiceKey.Anthropic"
        }
    }
}

#Preview {
    ServiceSelectorView()
}

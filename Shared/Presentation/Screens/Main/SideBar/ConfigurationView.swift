//
//  SettingsView2.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import SwiftUI

struct ConfigurationView<VM: ConfigurationViewModel>: View {
    @ObservedObject var vm: VM
    var body: some View {
        Form {
            Section("Model Settings") {
                secureTextField
                modelTypePicker
                temperatureSlider
                contextWindowStepper
                saveButton
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private var secureTextField: some View {
        SecureField("API Key", text: $vm.apiKey)
    }
    
    @ViewBuilder
    private var modelTypePicker: some View {
        Group {
            if let openAIVM = vm as? (any OpenAIConfigurationViewModel) {
                openAIModelPicker(openAIVM)
            } else if let anthropicVM = vm as? (any AnthropicConfigurationViewModel) {
                anthropicModelPicker(anthropicVM)
            }
        }
    }
    
    private func openAIModelPicker(_ vm: any OpenAIConfigurationViewModel) -> some View {
        Picker("Model", selection: Binding(
            get: { vm.selectedModel },
            set: { vm.selectedModel = $0 }
        )) {
            ForEach(OpenAIModelType.allCases, id: \.self) { model in
                Text(model.rawValue).tag(model)
            }
        }
    }
    
    private func anthropicModelPicker(_ vm: any AnthropicConfigurationViewModel) -> some View {
        Picker("Model", selection: Binding(
            get: { vm.selectedModel },
            set: { vm.selectedModel = $0 }
        )) {
            ForEach(AnthropicModelType.allCases, id: \.self) { model in
                Text(model.rawValue).tag(model)
            }
        }
    }
    
    private var temperatureSlider: some View {
        VStack(alignment: .leading) {
            Text("Temperature: \(vm.temperature, specifier: "%.2f")")
            Slider(value: $vm.temperature, in: 0...1, step: 0.1)
        }
    }
    
    private var contextWindowStepper: some View {
        Stepper("Context Window: \(vm.contextWindowSize)", value: $vm.contextWindowSize, in: 1...20)
    }
    
    private var saveButton: some View {
        Button("Save Changes", action: vm.save)
    }
}
struct ServiceProviderConfigView: View {
    @State private var provider: ServiceKey = .openAIAPIKey
    let configStore: any ConfigurationStore
    
    @StateObject var openAIViewModel = OpenAIConfigViewModelImpl(configStore: ConfigurationStoreImpl() )
    @StateObject var anthropicViewModel = AnthropicConfigurationViewModelImpl(configStore: ConfigurationStoreImpl())
    
    var body: some View {
        VStack {
            serviceSelectorPicker
            selectedView
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
    
    @ViewBuilder
    private var selectedView: some View {
        switch provider {
        case .openAIAPIKey:
            ConfigurationView(vm: openAIViewModel)
        case .anthropicAPIKey:
            ConfigurationView(vm: anthropicViewModel)
        }
    }
}



enum ServiceKey: String, CaseIterable, Codable{
    case openAIAPIKey
    case anthropicAPIKey
    
    var displayName: String {
        switch self {
        case .openAIAPIKey: return "OpenAI"
        case .anthropicAPIKey: return "Anthropic"
        }
    }
}
#Preview {
//   ConfigurationView(vm: ConfigViewModelImpl(configStore: ConfigurationStoreImpl()))
    ServiceProviderConfigView(configStore: ConfigurationStoreImpl())
   
}

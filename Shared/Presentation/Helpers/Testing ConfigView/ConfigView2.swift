//
//  ConfigView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/24.
//

import SwiftUI


struct ConfigurationView2<VM: ConfigurationViewModel>: View {
    @StateObject var viewModel: VM
    
    var body: some View {
    
        Form {
            Section(header: Text("AI Service Provider")) {
                Picker("Provider", selection: $viewModel.selectedProvider) {
                    ForEach(ServiceProvider.allCases) { provider in
                        Text(provider.rawValue).tag(provider)
                    }
                }
            }
            
            Section(header: Text("API Settings")) {
                SecureFloatingLabelTextField(title: "API KEY", text: Binding(
                    get: { viewModel.apiKeys[viewModel.selectedProvider] ?? "" },
                    set: { viewModel.apiKeys[viewModel.selectedProvider] = $0 }
                ))
                .textContentType(.password)

                
                Picker("Model", selection: $viewModel.selectedModelName) {
                    ForEach(viewModel.modelsForSelectedProvider(), id: \.name) { model in
                        Text(model.name).tag(model.name)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Temperature: \(viewModel.temperature, specifier: "%.2f")")
                    Slider(value: $viewModel.temperature, in: 0...1, step: 0.1)
                }
                
                Stepper("Context Window: \(viewModel.contextWindowSize)", value: $viewModel.contextWindowSize, in: 1...20)
            }
            
            Section {
                Button("Save Changes") {
                    viewModel.save()
                }
            }
        }
    }
}


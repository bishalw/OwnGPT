//
//  OpenAIConfigurationView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Foundation
import SwiftUI

struct OpenAIConfigurationView<VM: OpenAIConfigurationViewModel>: View {
    
    @ObservedObject var vm: VM
    
    let didSave: () -> Void
    var body: some View {
        Form {
            Section("OpenAI Model Settings") {
                SecureField("API Key", text: $vm.apiKey)
                    .textContentType(.password)
                SecureFloatingLabelTextField(title: "APIKey", text: $vm.apiKey)
                
                Picker("Model", selection: $vm.selectedModel) {
                    ForEach(OpenAIModelType.allCases, id: \.self) { model in
                        Text(model.displayName).tag(model)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Temperature: \(vm.temperature, specifier: "%.2f")")
                    Slider(value: $vm.temperature, in: 0...1, step: 0.1)
                }
                
                Stepper("Context Window: \(vm.contextWindowSize)", value: $vm.contextWindowSize, in: 1...20)
                
                Button("Save Changes") {
                    didSave()
                    vm.save()
                    Task {
                        await vm.setOpenAPIKey()

                    }
                }
            }
        }

        .scrollContentBackground(.hidden)
        .onDisappear {
            vm.save()
            Task {
                await vm.setOpenAPIKey()
            }
        }
        
    }
}

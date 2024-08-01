//
//  AnthropicConfigurationView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import SwiftUI

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

#Preview {
  EmptyView()
}

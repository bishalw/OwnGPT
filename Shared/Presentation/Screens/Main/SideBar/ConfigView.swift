//
//  SettingsView2.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import SwiftUI

struct ConfigView: View {
    
    @StateObject  var vm: ConfigViewModel
    @State var password: String = ""
    var body: some View {
        Form {
            Section("Model Settings") {
                SecureFloatingLabelTextField(title: "API Key", text: $password)
                Picker("Model Provider", selection: $vm.modelProvider) {
                    ForEach(ModelProvider.allCases) { model in
                        Text(model.rawValue).tag(model)
                    }
                }
                Picker("Model", selection: $vm.selectedModel) {
                    ForEach(OpenAIModelType.allCases) { model in
                        Text(model.rawValue).tag(model)
                    }
                }
                VStack(alignment: .leading) {
                    Text("Temperature: \(vm.temperature, specifier: "%.2f")")
                    Slider(value: $vm.temperature, in: 0...1, step: 0.1)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Stepper(value: $vm.contextWindowSize, in: 1...20) {
                        Text("Context Window  \(vm.contextWindowSize)")
                    }
                    Text("Determines how many previous messages the AI considers. Larger size allows for more context but may slow down responses.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    vm.save()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                }
                
            }
        }
        .scrollContentBackground(.hidden)

    }
}

//#Preview {
//    ConfigView(vm: ConfigViewModel() )
//}

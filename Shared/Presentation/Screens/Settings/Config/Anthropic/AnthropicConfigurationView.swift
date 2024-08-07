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
            WIPMessageView()
            #if DEBUG
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
            #endif
        }
        .scrollContentBackground(.hidden)
    }
}
struct WIPMessageView: View {
    let message: String
    
    init(_ message: String = "Currently not supported") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text("Work in Progress")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding()
    }
}


#Preview {
  EmptyView()
}

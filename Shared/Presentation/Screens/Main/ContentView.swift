//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/23/24.
//

import SwiftUI
//
//enum AIServiceProvider: String, CaseIterable, Identifiable {
//    case openAI = "OpenAI"
//    case googleAI = "Google AI"
//    case anthropic = "Anthropic"
//    case microsoftAI = "Microsoft AI"
//    
//    var id: String { self.rawValue }
//}
//
//struct AIServiceConfiguration: Identifiable {
//    let id = UUID()
//    var provider: AIServiceProvider
//    var selectedModel: String
//    var availableModels: [String]
//    var temperature: Double
//    var contextWindow: Int
//    var apiKey: String
//}
//
//class AIServicesModel: ObservableObject {
//    @Published var selectedProvider: AIServiceProvider = .openAI
//    @Published var configurations: [AIServiceConfiguration] = [
//        AIServiceConfiguration(provider: .openAI, selectedModel: "GPT-4", availableModels: ["GPT-4", "GPT-3.5"], temperature: 0.7, contextWindow: 8000, apiKey: ""),
//        AIServiceConfiguration(provider: .googleAI, selectedModel: "PaLM", availableModels: ["PaLM", "LaMDA"], temperature: 0.5, contextWindow: 6000, apiKey: ""),
//        AIServiceConfiguration(provider: .anthropic, selectedModel: "Claude", availableModels: ["Claude", "Claude 2"], temperature: 0.6, contextWindow: 10000, apiKey: ""),
//        AIServiceConfiguration(provider: .microsoftAI, selectedModel: "GPT-3", availableModels: ["GPT-3", "GPT-4"], temperature: 0.8, contextWindow: 7000, apiKey: "")
//    ]
//    
//    func currentConfiguration() -> Binding<AIServiceConfiguration> {
//        let index = configurations.firstIndex(where: { $0.provider == selectedProvider })!
//        return Binding<AIServiceConfiguration>(
//            get: { self.configurations[index] },
//            set: { self.configurations[index] = $0 }
//        )
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var model = AIServicesModel()
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("AI Service Provider")) {
//                    Picker("Select Provider", selection: $model.selectedProvider) {
//                        ForEach(AIServiceProvider.allCases) { provider in
//                            Text(provider.rawValue).tag(provider)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
//                
//                AIServiceConfigView(configuration: model.currentConfiguration())
//            }
//            .navigationTitle("AI Service Configuration")
//        }
//    }
//}
//
//struct AIServiceConfigView: View {
//    @Binding var configuration: AIServiceConfiguration
//    
//    var body: some View {
//        Section(header: Text("Model Configuration")) {
//            Picker("Model", selection: $configuration.selectedModel) {
//                ForEach(configuration.availableModels, id: \.self) { model in
//                    Text(model).tag(model)
//                }
//            }
//            
//            VStack {
//                Text("Temperature: \(configuration.temperature, specifier: "%.2f")")
//                Slider(value: $configuration.temperature, in: 0...1, step: 0.1)
//            }
//            
//            Stepper("Context Window: \(configuration.contextWindow)", value: $configuration.contextWindow, in: 1000...20000, step: 1000)
//            
//            SecureField("API Key", text: $configuration.apiKey)
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

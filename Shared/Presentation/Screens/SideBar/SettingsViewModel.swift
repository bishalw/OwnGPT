//
//  SettingsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    
    @Published var modelAIConfig: OpenAIModelConfig = .init()
    var contextWindowSize: Int {
        get { modelAIConfig.contextWindowSize }
        set { modelAIConfig.contextWindowSize = newValue }
    }
    var temperature: Double {
        get { modelAIConfig.temperature }
        set { modelAIConfig.temperature = newValue }
    }
    var selectedModel: OpenAIModelType {
        get { modelAIConfig.model }
        set { modelAIConfig.model = newValue}
    }
    @Published var modelProvider: ModelProvider = .openAI
    
}



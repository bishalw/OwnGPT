//
//  SettingsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import Foundation

class ConfigViewModel: ObservableObject {

    @Published var modelAIConfig: OpenAIModelConfig = .init()
    @Published var modelProvider: ModelProvider = .openAI
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
}



//
//  OpenAIConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

struct OpenAIConfig {
    var modelConfig: OpenAIModelConfig
    var apiKey: String
    
    init(modelConfig: OpenAIModelConfig, apiKey: String) {
        self.modelConfig = modelConfig
        self.apiKey = apiKey
    }
}

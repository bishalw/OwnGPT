//
//  OpenAIConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

struct OpenAIConfig {
    var modelConfig: OpenAIModelConfig
    var apiKey: APIKey
    
    init(modelConfig: OpenAIModelConfig, apiKey: APIKey) {
        self.modelConfig = modelConfig
        self.apiKey = apiKey
    }
}


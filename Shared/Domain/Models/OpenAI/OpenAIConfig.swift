//
//  OpenAIConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

struct OpenAIConfig: ServiceProvider, Codable {
    var modelConfig: OpenAILMConfig
    var apiKey: APIKey
    
    init(modelConfig: OpenAILMConfig, apiKey: APIKey) {
        self.modelConfig = modelConfig
        self.apiKey = apiKey
    }
}




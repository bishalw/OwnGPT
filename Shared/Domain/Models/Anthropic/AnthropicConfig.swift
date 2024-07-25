//
//  AnthropicConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/23/24.
//

import Foundation

struct AnthropicConfig: ServiceProvider {
    var modelConfig: AnthropicLMConfig
    var apiKey: APIKey
    
    init(modelConfig: AnthropicLMConfig, apiKey: APIKey) {
        self.modelConfig = modelConfig
        self.apiKey = apiKey
    }
}

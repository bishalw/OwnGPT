//
//  AnthropicModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/23/24.
//

import Foundation

struct AnthropicLMConfig: BaseModelConfig {
    typealias modelType = AnthropicModelType
    var model: modelType
    var maxTokens: Int
    var temperature: Double
    var topP: Double
    var contextWindowSize: Int 
    
    init(model: AnthropicModelType = .claude, maxTokens: Int = 2048, temperature: Double = 0.7, topP: Double = 1.0, frequencyPenalty: Double = 0.0, presencePenalty: Double = 0.0, contextWindowSize: Int = 5) {
        self.model = model
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.topP = topP
        self.contextWindowSize = contextWindowSize
    }
}

enum AnthropicModelType: String, ModelType{
    case claude = "claude"
    case claude3_5 = "claude3_5"
    case opus = "opus"
    case sonnet = "sonnet"
    
    var name: String { self.rawValue }
}

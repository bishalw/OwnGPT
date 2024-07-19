//
//  OpenAIModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

struct OpenAIModelConfig: BaseModelConfig {
    var model: OpenAIModelType
    let maxTokens: Int
    var temperature: Double
    let topP: Double
    let frequencyPenalty: Double
    let presencePenalty: Double
    var contextWindowSize: Int 
    
    init(model: OpenAIModelType = .gpt3_5, maxTokens: Int = 2048, temperature: Double = 0.7, topP: Double = 1.0, frequencyPenalty: Double = 0.0, presencePenalty: Double = 0.0, contextWindowSize: Int = 5) {
        self.model = model
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.topP = topP
        self.frequencyPenalty = frequencyPenalty
        self.presencePenalty = presencePenalty
        self.contextWindowSize = contextWindowSize
    }
}

enum OpenAIModelType: String, CaseIterable, Identifiable, Hashable{
    case gpt3_5 = "GPT-3.5"
    case gpt4 = "GPT-4"
    case gpt4Turbo = "GPT-4 Turbo"
    case gpt4Vision = "GPT-4 Vision"
    
    var id: String { self.rawValue }
}



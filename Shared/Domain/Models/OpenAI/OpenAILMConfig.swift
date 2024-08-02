//
//  OpenAIModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

struct OpenAILMConfig: BaseModelConfig, Codable{
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

protocol ModelType: Hashable, CaseIterable, Codable {
    var name: String { get }
}
enum OpenAIModelType: String, ModelType{
    case gpt3_5
    case gpt4
    case gpt4Turbo
    case gpt4Vision
    
    var displayName: String {
        switch self {
        case .gpt3_5:
            "GPT-3.5"
        case .gpt4:
            "GPT-4"
        case .gpt4Turbo:
            "GPT-4"
        case .gpt4Vision:
            "GPT-4 Vision"
        }
    }
    
    var modelName: String {
        switch self {
        case .gpt3_5:
            "gpt-3.5-turbo"
        case .gpt4:
            "gpt-3.5-turbo"
        case .gpt4Turbo:
            "gpt-4-turbo"
        case .gpt4Vision:
            "gpt-3.5-turbo"
        }
    }
    
    var name: String { self.rawValue }
}



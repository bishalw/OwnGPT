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
    
    init(model: OpenAIModelType = .gpt3_5Turbo, maxTokens: Int = 2048, temperature: Double = 0.7, topP: Double = 1.0, frequencyPenalty: Double = 0.0, presencePenalty: Double = 0.0, contextWindowSize: Int = 5) {
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
    case gpt3_5Turbo
    case gpt4o
    case gpt4o_mini
    case gpt4
    
    var displayName: String {
        switch self {
        case .gpt3_5Turbo:
            "GPT-3.5 Turbo"
        case .gpt4o:
            "GPT-4o"
        case .gpt4o_mini:
            "GPT-4o-mini"
        case .gpt4:
            "GPT-4"
        }
    }
    
    var modelName: String {
        switch self {
        case .gpt3_5Turbo:
            "gpt-3.5-turbo"
        case .gpt4o:
            "gpt-4o"
        case .gpt4o_mini:
            "gpt-4o-mini"
        case .gpt4:
            "gpt-4-turbo"
        }
    }
    
    var name: String { self.rawValue }
}



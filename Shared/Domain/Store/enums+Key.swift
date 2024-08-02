//
//  enums+Key.swift
//  OwnGpt
//
//  Created by Bishalw on 8/1/24.
//

import Foundation

enum userDefaultsKey: String {
    case hasOnboarded
    case openAIConfig
}
enum keyChainKey: String, CaseIterable, Codable{
    case openAIAPIKey
    case anthropicAPIKey
    
    var displayName: String {
        switch self {
        case .openAIAPIKey:
            return "OpenAI"
        case .anthropicAPIKey:
            return "Anthropic"
        }
    }
    var keyName: String {
        switch self {
            
        case .openAIAPIKey:
            return "com.OwnGPT.ServiceKey.OpenAI"
        case .anthropicAPIKey:
            return "com.OwnGPT.ServiceKey.Anthropic"
        }
    }
}

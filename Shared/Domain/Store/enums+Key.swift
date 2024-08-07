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
enum serviceProvider: String, CaseIterable, Codable{
    case openAI
    case anthropic
    
    var displayName: String {
        switch self {
        case .openAI:
            return "OpenAI"
        case .anthropic:
            return "Anthropic"
        }
    }
    var keyName: String {
        switch self {
            
        case .openAI:
            return "com.OwnGPT.ServiceKey.OpenAI"
        case .anthropic:
            return "com.OwnGPT.ServiceKey.Anthropic"
        }
    }
}

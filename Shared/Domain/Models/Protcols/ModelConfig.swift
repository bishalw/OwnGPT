//
//  ModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

protocol ModelConfig {
    var provider: ModelProvider { get }
}

enum ModelProvider: String, CaseIterable, Identifiable {
    case openAI = "OpenAI"
//    case anthropic = "Claude"
//    case google = "Gemini"
    
    var id: String { self.rawValue }
}

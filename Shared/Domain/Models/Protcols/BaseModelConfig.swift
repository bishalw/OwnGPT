//
//  BaseModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

protocol BaseModelConfig {
    associatedtype ModelType
    
    var model: ModelType { get }
    var maxTokens: Int { get }
    var temperature: Double { get }
    var topP: Double { get }
}

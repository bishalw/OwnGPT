//
//  BaseModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

protocol BaseModelConfig: Codable{
    associatedtype ModelType
    var model: ModelType { get set }
    var maxTokens: Int { get }
    var temperature: Double { get set }
    var topP: Double { get }
    var contextWindowSize: Int { get set }
}

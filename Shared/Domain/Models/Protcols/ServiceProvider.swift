//
//  ModelConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

protocol ServiceProvider: Codable {
    associatedtype Provider
    var modelConfig: Provider { get }
    var apiKey: APIKey { get }
}

//
//  OpenAIConfigStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Foundation
import Combine

protocol OpenAiConfigStore {
    var openAIKeyPublisher: AnyPublisher<String, Never> { get }
    func fetchOpenAPIKey() async -> String
    func setOpenAPIKey(_ key: String) async
    
}


class OpenAIConfigStoreImpl: OpenAiConfigStore {
    private let observableKeyChainService: ObservableKeyChainService

    private let observableUserDefaults: ObservableUserDefaultService
    
    init(observableUserDefaults: ObservableUserDefaultService,
        observableKeyChainService: ObservableKeyChainService) {
        self.observableUserDefaults = observableUserDefaults
        self.observableKeyChainService = observableKeyChainService
    }

    var openAIKeyPublisher: AnyPublisher<String, Never> {
        observableKeyChainService.keyChainPublisher(forKey: keyChainKey.openAIAPIKey.rawValue, defaultValue: "")
    }

    func fetchOpenAPIKey() async -> String {
        let key = await observableKeyChainService.get(forKey: keyChainKey.openAIAPIKey.rawValue) ?? ""
        Log.shared.logger.info("Fetched OpenAI API Key: \(key)")
        return key
    }

    func setOpenAPIKey(_ key: String) async {
        Log.shared.logger.info("Setting OpenAI API Key: \(key)")
        await observableKeyChainService.set(key, forKey: keyChainKey.openAIAPIKey.rawValue)
    }
}

enum ConfigurationStoreError: Error {
    case failedToLoadAPIKey
    case failedToSaveAPIKey
    case failedToClearAPIKey
    case invalidServiceKey
    case failedToFetchOnInitialization
}

struct APIKey: Codable{
    let serviceKey: keyChainKey
    var value: String
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

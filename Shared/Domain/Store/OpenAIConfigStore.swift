//
//  OpenAIConfigStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Foundation
import Combine

protocol OpenAIConfigStore {
    var openAILMConfig: OpenAILMConfig { get set}
    var openAILMConfigPublisher: AnyPublisher<OpenAILMConfig, Never> { get }
    var openAIKeyPublisher: AnyPublisher<String, Never> { get }
    func getValueForKey() async -> String
    func setKey(_ key: String) async
}


class OpenAIConfigStoreImpl: OpenAIConfigStore{
    private let observableKeyChainService: ObservableKeyChainService

    private let observableUserDefaultsService: ObservableUserDefaultService
    
    init(observableUserDefaults: ObservableUserDefaultService,
        observableKeyChainService: ObservableKeyChainService) {
        self.observableUserDefaultsService = observableUserDefaults
        self.observableKeyChainService = observableKeyChainService
    }
    
    
    var openAILMConfig: OpenAILMConfig {
        get {
           let config = self.observableUserDefaultsService.get(forKey: userDefaultsKey.openAIConfig.rawValue) ?? OpenAILMConfig()
            Log.shared.logger.info("Retrieved OpenAI config: \(config)")
            return config

        }
        set {
            self.observableUserDefaultsService.set(value: newValue, forKey: userDefaultsKey.openAIConfig.rawValue)
            Log.shared.logger.info("Saved OpenAI config: \(newValue)")
            
        }
    }
    
//    var openAILMConfigPublisher: AnyPublisher<OpenAILMConfig, Never> {
//        return self.observableUserDefaultsService.userDefaultsPublisher(forKey: userDefaultsKey.openAIConfig.rawValue, defaultValue: OpenAILMConfig())
//    }
    var openAILMConfigPublisher: AnyPublisher<OpenAILMConfig, Never> {
        let publisher = self.observableUserDefaultsService.userDefaultsPublisher(forKey: userDefaultsKey.openAIConfig.rawValue, defaultValue: OpenAILMConfig())
        Log.shared.logger.info("Created openAILMConfigPublisher")
        return publisher.handleEvents(receiveOutput: { value in
            Log.shared.logger.info("openAILMConfigPublisher emitted: \(value)")
        }).eraseToAnyPublisher()
    }
    
    var openAIKeyPublisher: AnyPublisher<String, Never> {
        observableKeyChainService.keyChainPublisher(forKey: keyChainKey.openAIAPIKey.rawValue, defaultValue: "")
    }
    
    func getValueForKey() async -> String {
        let key = await observableKeyChainService.get(forKey: keyChainKey.openAIAPIKey.rawValue) ?? ""
//        Log.shared.logger.info("Fetched OpenAI API Key: \(key)")
        return key
    }

    func setKey(_ key: String) async {
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


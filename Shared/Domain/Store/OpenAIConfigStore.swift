//
//  OpenAIConfigStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Foundation
import Combine

protocol OpenAiConfigStore {
    var openAIApiKeyPublisher: AnyPublisher<APIKey?, Never> { get }
}

class OpenAIConfigStoreImpl: OpenAiConfigStore {
    
    // MARK: Exposed Properties
    var openAIApiKeyPublisher: AnyPublisher<APIKey?, Never> {
        openAIApiKeySubject.eraseToAnyPublisher()
    }
    // MARK: Private Properites
    private var openAIApiKeySubject: CurrentValueSubject<APIKey?, Never>
    
    //MARK: Dependency
    private let observableUserDefaults: ObservableUserDefaultService
    private let keychainService: KeyChainService
    
    init(observableUserDefaults: ObservableUserDefaultService, keychainService: KeyChainService) {
        self.observableUserDefaults = observableUserDefaults
        self.keychainService = keychainService
        self.openAIApiKeySubject = CurrentValueSubject.init(nil)
        setupInitialFetch()
    }
    private func setupInitialFetch() {
        Task {
            do {
                try await fetchAPIKey()
            } catch {
                throw ConfigurationStoreError.failedToFetchOnInitialization
            }
        }
    }
    
    func fetchAPIKey() async throws {
        do {
            if let apiKey: APIKey = try await keychainService.retrieve(ServiceKey.openAIAPIKey.rawValue) {
                openAIApiKeySubject.send(apiKey)
            } else {
                openAIApiKeySubject.send(nil)
            }
        } catch {
            throw ConfigurationStoreError.failedToLoadAPIKey
        }
    }
    
    func saveAPIKey(_ apiKey: APIKey) async throws {
        do {
            try await keychainService.save(apiKey, for: ServiceKey.openAIAPIKey.rawValue)
            openAIApiKeySubject.send(apiKey)
        } catch {
            throw ConfigurationStoreError.failedToSaveAPIKey
        }
    }
    
    func clearAPIKey(for key: ServiceKey) async throws {
        do {
            try await keychainService.delete(for: key.rawValue)
            openAIApiKeySubject.send(nil)
        } catch  {
            throw ConfigurationStoreError.failedToClearAPIKey
        }
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
    let serviceKey: ServiceKey
    var value: String
    
    
}
enum ServiceKey: String, CaseIterable, Codable{
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

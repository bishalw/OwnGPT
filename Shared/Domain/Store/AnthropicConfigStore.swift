//
//  AnthropicConfigStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Foundation
import Combine

protocol AnthropicConfigStore {
    var anthropicAPIKeyPublisher: AnyPublisher<APIKey?, Never> { get }
}
class AnthropicConfigStoreImpl: AnthropicConfigStore {
    

    // MARK: Exposed Properties
    var anthropicAPIKeyPublisher: AnyPublisher<APIKey?, Never> {
        anthropicAPIKeySubject.eraseToAnyPublisher()
    }
    private var anthropicAPIKeySubject: CurrentValueSubject<APIKey?, Never>
    
    //MARK: Dependency
    private let observableUserDefaults: ObservableUserDefaultService
    private let keychainService: KeyChainService
    
    init(observableUserDefaults: ObservableUserDefaultService, keychainService: KeyChainService) {
        self.observableUserDefaults = observableUserDefaults
        self.keychainService = keychainService
        self.anthropicAPIKeySubject = CurrentValueSubject.init(nil)
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
            if let apiKey: APIKey = try await keychainService.retrieve(ServiceKey.anthropicAPIKey.rawValue) {
                anthropicAPIKeySubject.send(apiKey)
            } else {
                anthropicAPIKeySubject.send(nil)
            }
        } catch {
            throw ConfigurationStoreError.failedToLoadAPIKey
        }
    }
    
    func saveAPIKey(_ apiKey: APIKey) async throws {
        do {
            try await keychainService.save(apiKey, for: ServiceKey.anthropicAPIKey.rawValue)
            anthropicAPIKeySubject.send(apiKey)
        } catch {
            throw ConfigurationStoreError.failedToSaveAPIKey
        }
    }
    
    func clearAPIKey(for key: ServiceKey) async throws {
        do {
            try await keychainService.delete(for: key.rawValue)
            anthropicAPIKeySubject.send(nil)
        } catch  {
            throw ConfigurationStoreError.failedToClearAPIKey
        }
    }
}

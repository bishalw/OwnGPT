//
//  ConfigurationStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/20/24.
//

import Foundation
import Combine

protocol ConfigurationStore: ObservableObject {
    var apiKeyPublisher: AnyPublisher<APIKey?, Never> { get }
}


class ConfigurationStoreImpl: ObservableObject, ConfigurationStore {
    private var apiKeySubject: CurrentValueSubject<APIKey?, Never>
    
    var apiKeyPublisher: AnyPublisher<APIKey?, Never> {
        apiKeySubject.eraseToAnyPublisher()
    }
    
    private let keychainService: KeyChainService
    private let userDefaultStore: any UserDefaultsStore
    
    init(
        keychainService: KeyChainService = KeyChainServiceImpl(),
        userDefaultStore: any UserDefaultsStore
    ) {
        self.keychainService = keychainService
        self.userDefaultStore = userDefaultStore
        self.apiKeySubject = CurrentValueSubject<APIKey?, Never>(nil)
    }
    
    func fetchAPIKey() async throws {
        do {
            if let apiKey: APIKey = try await keychainService.retrieve(ServiceKey.openAIAPIKey.rawValue) {
                apiKeySubject.send(apiKey)
            } else {
                // If no API key is found, we send nil to clear any previously stored value
                apiKeySubject.send(nil)
            }
        } catch {
            throw ConfigurationStoreError.failedToLoadAPIKey
        }
    }
    
    func saveAPIKey(_ apiKey: APIKey) async throws {
        do {
            try await keychainService.save(apiKey, for: apiKey.serviceKey.rawValue)
            apiKeySubject.send(apiKey)
        } catch {
            throw ConfigurationStoreError.failedToSaveAPIKey
        }
    }
    
    func clearAPIKey(for serviceKey: ServiceKey) async throws {
        do {
            try await keychainService.delete(for: serviceKey.rawValue)
            if serviceKey == .openAIAPIKey {
                apiKeySubject.send(nil)
            }
        } catch {
            throw ConfigurationStoreError.failedToClearAPIKey
        }
    }
}

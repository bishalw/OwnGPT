//
//  ConfigStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/20/24.
//

import Foundation

class ConfigStoreImpl: ObservableObject {
    private let keychainService: KeyChainService
    
    @Published private(set) var apiKey = APIKey(value: "", serviceKey: .openAiAPIKey)
    
    init(keychainService: KeyChainService = KeyChainServiceImpl()) {
        self.keychainService = keychainService
    }
    
    private func loadAPIKey() async {
        do {
            if let apiKey: APIKey = try await keychainService.retrieve(apiKey.serviceKey.rawValue) {
                    self.apiKey.value = apiKey.value
            }
        } catch {
            print("Failed to load API key: \(error)")
        }
    }
    
    func saveAPIKey(_ value: String) async throws {
        let apiKey = APIKey(value: value, serviceKey: .openAiAPIKey)
        try await keychainService.save(apiKey, for: ServiceKey.openAiAPIKey.rawValue)
            self.apiKey.value = value
    }
    
    func clearAPIKey() async throws {
        try await keychainService.delete(for: ServiceKey.openAiAPIKey.rawValue)
            self.apiKey.value = ""
    }
}

//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Bkit
import Combine

protocol UserDefaultsStore: ObservableObject {
    
    func clearCache()
    
}
class UserDefaultsStoreImpl: UserDefaultsStore {
    private var userdefaultsPublisher: any PublishingUserDefaultsService
    
    private var openAIConfigSubject = CurrentValueSubject<OpenAILMConfig, Never>(.init())
    private var cancellables = Set<AnyCancellable>()

    var openAIConfigPublisher: AnyPublisher<OpenAILMConfig, Never> {
        openAIConfigSubject.eraseToAnyPublisher()
    }

    init(userdefaultsPublisher: PublishingUserDefaultsService) {
        self.userdefaultsPublisher = userdefaultsPublisher
        setupObserver()
    }
    
    private func setupObserver() {
        // Load initial value
        if let savedConfig: OpenAILMConfig = userdefaultsPublisher.get(forKey: "openAIConfig") {
            openAIConfigSubject.send(savedConfig)
        }

        // Observe changes and save
        openAIConfigSubject
            .dropFirst() // Skip initial value
            .sink { [weak self] newConfig in
                self?.userdefaultsPublisher.set(value: newConfig, forKey: "openAIConfig")
            }
            .store(in: &cancellables)
    }
    
    func clearCache() {
        
    }

    // Public method to update the config
    func updateOpenAIConfig(_ newConfig: OpenAILMConfig) {
        openAIConfigSubject.send(newConfig)
    }
}

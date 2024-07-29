//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Bkit
import Combine

protocol UserDefaultsStore {
    var openAIConfigPublisher: AnyPublisher<OpenAILMConfig, Never> { get }
    var hasUserOnboardedPublisher: AnyPublisher<Bool, Never> { get }
    
    func updateOpenAIConfig(_ config: OpenAILMConfig)
    func updateHasUserOnboarded(_ value: Bool)
}

class UserDefaultsStoreImpl: UserDefaultsStore {

    // MARK: Dependency
    private let observableUserDefaultStore: ObservableUserDefaultStore
    
    // MARK: Private Publishers
    private let openAIConfigSubject = CurrentValueSubject<OpenAILMConfig, Never>(.init())
    private let hasUserOnboardedSubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Exposed Publishers
    var openAIConfigPublisher: AnyPublisher<OpenAILMConfig, Never> { openAIConfigSubject.eraseToAnyPublisher() }
    
    var hasUserOnboardedPublisher: AnyPublisher<Bool, Never> { hasUserOnboardedSubject.eraseToAnyPublisher() }
    
    init(observableUserDefaultStore: ObservableUserDefaultStore) {
        self.observableUserDefaultStore = observableUserDefaultStore
        setupObservers()
    }
    
    // MARK: Private functions
    private func setupObservers() {
        setupObserver(subject: openAIConfigSubject, key: "openAIConfig")
        setupObserver(subject: hasUserOnboardedSubject, key: "hasOnboarded")
    }
    
    private func setupObserver<T: Codable>(subject: CurrentValueSubject<T, Never>, key: String) {
        // Load initial value
        if let savedValue: T = observableUserDefaultStore.get(forKey: key) {
            subject.send(savedValue)
        }
        
        // Observe changes and save
        subject
            .dropFirst() // Skip initial value
            .sink { [weak self] newValue in
                self?.observableUserDefaultStore.set(value: newValue, forKey: key)
            }
            .store(in: &cancellables)
    }
    // MARK: Public functions
    func updateOpenAIConfig(_ config: OpenAILMConfig) {
        openAIConfigSubject.send(config)
    }
    
    func updateHasUserOnboarded(_ value: Bool) {
        hasUserOnboardedSubject.send(value)
    }
}

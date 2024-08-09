//
//  Core.swift
//  OwnGpt
//
//

import Foundation
import os
import Bkit

class Core: ObservableObject {
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Persistence
    
    private(set) lazy var persistenceController: PersistenceController = {
        PersistenceController()
    }()
    
    // MARK: - Services
    
    private(set) lazy var conversationPersistenceService: ConversationPersistenceService = {
        ConversationPersistenceService(manager: self.persistenceController)
    }()
    
    private(set) lazy var networkService: CombinedNetworkService = {
        NetworkServiceImpl()
    }()
    
    private(set) lazy var chatgptApiService: ChatGPTAPIService = {
        ChatGPTAPIServiceImpl(networkService: self.networkService, openAIConfigStore: openAIConfigStore)
    }()
    
    private(set) lazy var keychainService: KeyChainService = {
        KeyChainServiceImpl()
    }()
    
    // MARK: - Observable Services
    
    private(set) lazy var observableUserDefaultService: ObservableUserDefaultService = {
        ObservableUserDefaultsServiceImpl()
    }()
    
    private(set) lazy var observableKeyChainService: ObservableKeyChainService = {
        ObservableKeyChainServiceImpl(keychainService: keychainService)
    }()
    
    // MARK: - Repositories
    
    private(set) lazy var conversationRepository: ConversationRepository = {
        ConversationRepositoryImpl(conversationPersistenceService: self.conversationPersistenceService)
    }()
    
    // MARK: - Stores
    
    private(set) lazy var userDefaultStore: UserDefaultsStore = {
        UserDefaultsStoreImpl(observableUserDefaultService: self.observableUserDefaultService)
    }()
    
    private(set) lazy var conversationsStore: ConversationsStore = {
        ConversationsStore(repo: self.conversationRepository)
    }()
    
    private(set) lazy var openAIConfigStore: OpenAIConfigStore = {
        OpenAIConfigStoreImpl(observableUserDefaults: self.observableUserDefaultService, observableKeyChainService: self.observableKeyChainService)
    }()
    
    private(set) lazy var anthropicConfigStore: AnthropicConfigStore = {
        AnthropicConfigStoreImpl(observableUserDefaults: self.observableUserDefaultService, keychainService: keychainService)
    }()
}


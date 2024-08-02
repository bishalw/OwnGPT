//
//  Core.swift
//  OwnGpt
//
//

import Foundation
import os
import Bkit

class Core: ObservableObject {
    //Persistance Controller
    private(set) lazy var persistenceController: PersistenceController = {
        return PersistenceController()
    }()
    //MARK: Service
    // ConversationPersistance Service (Core Data)
    private(set) lazy var conversationPersistenceService: ConversationPersistenceService = {
        return ConversationPersistenceService(manager: self.persistenceController)
    }()
    // NetworkService
    private(set) lazy var networkService: CombinedNetworkService = {
        return NetworkServiceImpl()
    }()
    // API Service for ChatGPT
    private(set) lazy var chatgptApiService: ChatGPTAPIService = {
        return ChatGPTAPIServiceImpl(networkService: self.networkService, apiKey: Constants.apiKey, openAIConfigStore: openAIConfigStore)
    }()
    // Conversation Repository
    private(set) lazy var conversationRepository: ConversationRepository = {
        return ConversationRepositoryImpl(conversationPersistenceService: self.conversationPersistenceService)
    }()
    // Keychain Service
    private(set) lazy var keychainService: KeyChainService = {
        return KeyChainServiceImpl()
    }()
    
    // Observing DefaultUserService
    private(set) lazy var observableUserDefaultService: ObservableUserDefaultService = {
        return ObservableUserDefaultServiceImpl()
    }()
    
    private(set) lazy var observableKeyChainService: ObservableKeyChainService = {
        return ObservableKeyChainServiceImpl(keychainService: keychainService)
    }()
    // UserDefault Store
    private(set) lazy var userDefaultStore: UserDefaultsStore = {
        return UserDefaultsStoreImpl(observableUserDefaultService: self.observableUserDefaultService)
    }()
    // MARK: STORE
    // Conversation Store
    private(set) lazy var conversationsStore: ConversationsStore = {
        return ConversationsStore(repo: self.conversationRepository)
    }()
  
    // Open AI
    private(set) lazy var openAIConfigStore: OpenAIConfigStore = {
        return OpenAIConfigStoreImpl(observableUserDefaults: self.observableUserDefaultService, observableKeyChainService: self.observableKeyChainService)
    }()
    
    // Anthropic Store
    private(set) lazy var anthropicConfigStore: AnthropicConfigStore = {
        return AnthropicConfigStoreImpl(observableUserDefaults: self.observableUserDefaultService, keychainService: keychainService)
    }()
    
    
    
    init() {
        
    }
}



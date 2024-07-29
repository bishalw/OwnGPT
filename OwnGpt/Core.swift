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
        return ChatGPTAPIServiceImpl(networkService: self.networkService, apiKey: Constants.apiKey)
    }()
    // Conversation Repository
    private(set) lazy var conversationRepository: ConversationRepository = {
        return ConversationRepositoryImpl(conversationPersistenceService: self.conversationPersistenceService)
    }()
    
    // Observing DefaultUserService
    private (set) lazy var observableUserDefaultStore: any ObservableUserDefaultStore = {
        return ObservableUserDefaultStoreImpl()
    }()
    // UserDefault Store
    private(set) lazy var userDefaultStore: any UserDefaultsStore = {
        return UserDefaultsStoreImpl(observableUserDefaultStore: observableUserDefaultStore)
    }()
    // Conversation Store
    private(set) lazy var conversationsStore: ConversationsStore = {
        return ConversationsStore(repo: self.conversationRepository)
    }()
    // Keychain Service
    private(set) lazy var keychainService: KeyChainService = {
        return KeyChainServiceImpl()
    }()
    // Config Store
    private(set) lazy var configStore: any ConfigurationStore = {
        return ConfigurationStoreImpl(keychainService: self.keychainService, userDefaultStore: self.userDefaultStore)
    }()
}



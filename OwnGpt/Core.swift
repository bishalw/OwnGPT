//
//  Core.swift
//  OwnGpt
//
//

import Foundation
import os
import Bkit

class Core: ObservableObject {
    
    private(set) lazy var persistenceController: PersistenceController = {
        return PersistenceController()
    }()
    
    private(set) lazy var conversationPersistenceService: ConversationPersistenceService = {
        return ConversationPersistenceService(manager: self.persistenceController)
    }()
    
    private(set) lazy var networkService: CombinedNetworkService = {
        return NetworkServiceImpl()
    }()
    
    private(set) lazy var chatgptApiService: ChatGPTAPIService = {
        return ChatGPTAPIServiceImpl(networkService: self.networkService, apiKey: Constants.apiKey)
    }()
    
    private(set) lazy var conversationRepository: ConversationRepository = {
        return ConversationRepositoryImpl(conversationPersistenceService: self.conversationPersistenceService)
    }()

    private(set) lazy var userDefaultStore: any UserDefaultsStore = {
        return UserDefaultsStoreImpl()
    }()
    
    private(set) lazy var conversationsStore: ConversationsStore = {
        return ConversationsStore(repo: self.conversationRepository)
    }()
    
}

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
    
    private(set) lazy var chatgptApiService: ChatGPTAPIServiceImpl = {
        return ChatGPTAPIServiceImpl(networkService: self.networkService, apiKey: Constants.apiKey)
    }()
    
    private(set) lazy var conversationRepository: ConversationRepositoryImpl = {
        return ConversationRepositoryImpl(conversationPersistenceService: self.conversationPersistenceService)
    }()

    private(set) lazy var userDefaultStore: UserDefaultsStore = {
        return UserDefaultsStore()
    }()
    
    private(set) lazy var conversationsStore: ConversationsStore = {
        return ConversationsStore(repo: self.conversationRepository)
    }()
    
}

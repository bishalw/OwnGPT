//
//  Core.swift
//  OwnGpt
//
//

import Foundation
import os
class Core: ObservableObject {
    
    private(set) lazy var persistenceController: PersistenceController = {
        return PersistenceController()
    }()
    
    private(set) lazy var conversationPersistenceService: ConversationPersistenceService = {
        return ConversationPersistenceService(manager: self.persistenceController)
    }()
    
    private(set) lazy var networkService: NetworkStreamingService = {
        return NetworkServiceImpl()
    }()
    
    private(set) lazy var chatgptApiService: ChatGPTAPIServiceImpl = {
        return ChatGPTAPIServiceImpl(networkService: self.networkService, apiKey: Constants.apiKey)
    }()
    
    private(set) lazy var conversationRepository: ConversationRepositoryImpl = {
        return ConversationRepositoryImpl(conversationPersistenceService: self.conversationPersistenceService)
    }()
    
    private(set) lazy var conversationStore: ConversationStore = {
        return ConversationStore(chatGPTAPI: self.chatgptApiService, repo: self.conversationRepository)
    }()
    
    private(set) lazy var conversationsStore: ConversationsStore = {
        return ConversationsStore(repo: self.conversationRepository)
    }()
}

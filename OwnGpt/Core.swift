//
//  Core.swift
//  OwnGpt
//
//

import Foundation
import os
class Core: ObservableObject {
    
    private (set) lazy var persistanceController = PersistenceController()
    private (set) lazy var conversationPersistenceService = ConversationPersistenceService(manager: persistanceController)
    private (set) lazy var networkService = NetworkServiceImpl()
    private (set) lazy var chatgptApiService = ChatGPTAPIServiceImpl(networkService: networkService, apiKey: Constants.apiKey)
    private (set) lazy var conversationRepository = ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: persistanceController))
    private (set) lazy var conversationStore = ConversationStore(chatGPTAPI: chatgptApiService, repo: conversationRepository)
    private (set) lazy var conversationsStore: ConversationsStore = {
        return ConversationsStore(repo: conversationRepository)
    }()
}

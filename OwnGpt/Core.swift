//
//  Core.swift
//  OwnGpt
//
//  Created by Bishalw on 12/12/23.
//

import Foundation

class Core: ObservableObject {
    private var router = Router()
    private lazy var persistanceController = PersistenceController()
    private lazy var conversationPersistenceService = ConversationPersistenceService(manager: persistanceController)
    lazy var conversationRepository = ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: PersistenceController()))
//    lazy var chatGPTAPIService = ChatGPTAPIService(apiKey: Constants.apiKey)
}

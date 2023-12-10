//
//  CoreDataService.swift
//  OwnGpt
//
//  Created by Bishalw on 12/1/23.
//

import Foundation
import CoreData

protocol PersistenceService {
    associatedtype T
    func get () async -> T
    func add (_ item:T )
    func update (_ item: T)
    func save()
}

class ConversationCoreDataService: PersistenceService {
    private let manager: PersistenceController
    private let sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
    
    init(manager: PersistenceController) {
        self.manager = manager
    }
    func get() async -> Conversation {
        
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.sortDescriptors = sortDescriptors
        
        do {
                let result = try manager.context.fetch(request)
                return result.compactMap { Conversation.from(entity: $0) }.first ?? Conversation(id: UUID(), messages: [])
            } catch {
                return Conversation(id: UUID(), messages: [])
            }

    }
    
    func add(_ item: Conversation) {
        let entity = ConversationEntity(context: manager.context)
        
    }
    
    func update(_ item: Conversation) {
        
    }
    
    func save() {
        
    }
}




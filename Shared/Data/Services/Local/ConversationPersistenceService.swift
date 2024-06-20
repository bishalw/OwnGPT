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
    func get () async throws -> [T]
    func get (id: UUID) async throws -> T
    func add (_ item:T )
    func save()
}

class ConversationPersistenceService: PersistenceService {
    
    private let manager: PersistenceController
    private let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
    
    init(manager: PersistenceController) {
        self.manager = manager
    }
    

    func get(id: UUID) async throws -> Conversation {
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let result = try await manager.backgroundContext.performFetch(request)
        return result.first?.from() ?? Conversation(id: UUID(), messages: [])
    }
    
    func add(_ item: Conversation) {
        let context = self.manager.context
       
        let _ =  item.toConversationEntity(context: context)
        save()
    }
    
    func get() async throws -> [Conversation] {
        do {

            let result = try await manager.backgroundContext.performFetch(request)
            // Convert the result from [ConversationEntity] to [Conversation]
            return result.map { $0.from() }
        } catch  {
            print("Error fetching conversation")
            throw error
        }
    }
    
    func save() {
        manager.saveContext()
    }
}




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
    func get () async throws -> T
//    func get (id: String) async throws -> T 
    func add (_ item:T )
    func save()
}

class ConversationPersistenceService: PersistenceService {
//    func get(id: String) async throws -> Conversation {
//
//    }
    
    private let manager: PersistenceController
    private let sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
    
    init(manager: PersistenceController) {
        self.manager = manager
    }
    

    func get() async throws -> Conversation {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.sortDescriptors = self.sortDescriptors

        let result = try await manager.backgroundContext.performFetch(request)
        return result.first?.from() ?? Conversation(id: UUID(), messages: [])
    }
    
    func add(_ item: Conversation) {
        let context = self.manager.context
        // Convert the Conversation to ConversationEntity
        _ =  item.toConversationEntity(context: context)
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func getConversations() async throws -> [Conversation] {
        do {
            let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
            request.sortDescriptors = self.sortDescriptors

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




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
    func add (_ item:T )
    func save()
}

class ConversationCoreDataService: PersistenceService {
    private let manager: PersistenceController
    private let sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
    
    init(manager: PersistenceController) {
        self.manager = manager
    }
    

    func get() async throws -> Conversation {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.sortDescriptors = self.sortDescriptors

        let result = try await manager.context.performFetch(request)
        return result.first?.from() ?? Conversation(id: UUID(), messages: [])
    }
    
    
    func add(_ item: Conversation) {
        let context = self.manager.context // Replace with your context retrieval logic
        
        // Convert the Conversation to ConversationEntity (creates or updates)
        let conversationEntity =  item.toConversationEntity(context: context)
        do {
            // Save the context to persist changes
            try context.save()
        } catch {
            // Handle the error, such as logging or notifying the user
            print("Error saving context: \(error)")
        }
        
    }
    
    func save() {
        manager.saveContext()
    }
}




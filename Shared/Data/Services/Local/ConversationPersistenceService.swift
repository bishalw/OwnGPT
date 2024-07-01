//
//  CoreDataService.swift
//  OwnGpt
//

//

import Foundation
import CoreData

protocol PersistenceService {
    associatedtype T
    func get () async throws -> [T]
    func get (id: UUID) async throws -> T
    func add (_ item: T ) async throws
    func deleteAll () async throws
    func delete(_ item: T) async throws
    
}

class ConversationPersistenceService: PersistenceService {
    
    private let manager: PersistenceController
    
    init(manager: PersistenceController) {
        self.manager = manager
    }
    
    func get(id: UUID) async throws -> Conversation {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        return try await manager.backgroundContext.perform {
            let result = try request.execute()
            guard let entity = result.first else {
                throw NSError(domain: "ConversationPersistenceService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Conversation not found"])
            }
            guard let conversation = entity.toConversation() else {
                throw NSError(domain: "ConversationPersistenceService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to convert ConversationEntity to Conversation"])
            }
            return conversation
        }
    }
    
    func add(_ item: Conversation) async throws {
        try await manager.backgroundContext.performAsync { context in
            _ = item.toConversationEntity(context: context)
        }
        await save()
    }
    
    func getCount() async throws -> Int {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.resultType = .countResultType
        
        do {
            let count = try await manager.backgroundContext.performAsync { context in
                try context.count(for: request)
            }
            return count
        } catch {
            Log.shared.logger.error("Error fetching conversation count: \(error)")
            throw error
        }
    }
    
    func get() async throws -> [Conversation] {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        
        return try await manager.backgroundContext.perform {
            let result = try request.execute()
            let conversations = result.compactMap { $0.toConversation() }
            if conversations.count != result.count {
                Log.shared.logger.info("Some conversations failed to convert: \(result.count - conversations.count) failures")
            }
            return conversations
        }
    }
    
    func save() async {
        await manager.saveChanges()
    }
    
    func delete(_ conversation: Conversation) async throws {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", conversation.id as CVarArg)
        
        do {
            let result = try await manager.viewContext.performFetch(request)
            if let entity = result.first {
                try await manager.backgroundContext.performDelete(entity)
                await save()
            }
        } catch {
            Log.shared.logger.error("Error deleting conversation: \(error)")
            throw error
        }
    }
    
    func deleteAll() async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ConversationEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try await manager.backgroundContext.performBatchDelete(deleteRequest)
            await save()
            Log.shared.logger.info("All conversations deleted successfully.")
        } catch {
            Log.shared.logger.error("Error deleting all conversations: \(error)")
            throw error
        }
    }
    
    func getFirst() async throws -> Conversation? {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        return try await manager.backgroundContext.perform {
            let result = try request.execute()
            return result.first?.toConversation()
        }
    }
}

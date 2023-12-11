//
//  Conversation.swift
//  OwnGpt
//
//  Created by Bishalw on 8/28/23.
//

import Foundation
import CoreData

struct Conversation: Identifiable {
    var id: UUID
    var messages: [Message]

    init(id: UUID, messages: [Message]) {
       self.id = id
       self.messages = messages
    }
}

extension Conversation {
    func toConversationEntity(context: NSManagedObjectContext) -> ConversationEntity {
        let conversationEntity: ConversationEntity
        do {
            conversationEntity = try fetchConversationEntity(context: context) ?? createConversationEntity(context: context)
        } catch {
            print("Error fetching ConversationEntity: \(error)")
            conversationEntity = createConversationEntity(context: context)
        }
        updateConversationEntity(conversationEntity, context: context)
        return conversationEntity
    }

    private func fetchConversationEntity(context: NSManagedObjectContext) throws -> ConversationEntity? {
        let request: NSFetchRequest<ConversationEntity> = ConversationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        return try context.fetch(request).first
    }

    private func createConversationEntity(context: NSManagedObjectContext) -> ConversationEntity {
        let conversationEntity = ConversationEntity(context: context)
        conversationEntity.id = self.id
        return conversationEntity
    }

    private func updateConversationEntity(_ conversationEntity: ConversationEntity, context: NSManagedObjectContext) {
        let messageEntities = self.messages.map { $0.toMessageEntity(context: context) }
        if let oldMessages = conversationEntity.messages {
            conversationEntity.removeFromMessages(oldMessages)
        }
        let newMessageSet = NSSet(array: messageEntities)
        conversationEntity.addToMessages(newMessageSet)
    }


}



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

    init(id: UUID = UUID(), messages: [Message] = []) {
        self.id = id
        self.messages = messages
    }
}
extension Conversation {
    var firstMessagePreview: String {
        guard let firstMessage = messages.first?.content.text else {
            return "New Conversation"
        }
        if firstMessage.isEmpty {
            return "Empty message"
        }
        return String(firstMessage.prefix(26))
    }
}

extension Conversation {
    func toConversationEntity(context: NSManagedObjectContext) -> ConversationEntity {
        let conversationEntity: ConversationEntity
        do {
            conversationEntity = try fetchConversationEntity(context: context) ?? createConversationEntity(context: context)
        } catch {
            Log.shared.logger.error("Error fetching ConversationEntity: \(error)")
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
        // Remove old messages
        if let oldMessages = conversationEntity.messages as? Set<MessageEntity> {
            oldMessages.forEach { oldMessage in
                context.delete(oldMessage)
            }
        }
        
        // Create new message entities
        let messageEntities = self.messages.map { message -> MessageEntity in
            let entity = message.toMessageEntity(context: context)
            entity.conversation = conversationEntity
            return entity
        }
        
        // Set new messages
        conversationEntity.messages = NSSet(array: messageEntities)
    }
    func getOpenApiHistory() -> [OpenAiModels.Message] {
        self.messages.map { $0.toOpenAiMessage }
    }
}

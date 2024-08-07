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
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    

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
    
    var lastMessagePreview: String {
           guard let lastMessage = messages.last else {
               return "No messages"
           }
           return lastMessage.content.text.trimmingCharacters(in: .whitespacesAndNewlines)
       }
}

extension Conversation {
    func getOpenApiHistory() -> [OpenAiModels.Message] {
        self.messages.map { $0.toOpenAiMessage }
    }
}

extension Conversation {
    func toConversationEntity(context: NSManagedObjectContext) -> ConversationEntity {
           let entity = ConversationEntity(context: context)
           entity.id = self.id
           entity.createdAt = self.createdAt
           entity.updatedAt = self.updatedAt
           
           // Convert and add messages using the existing toMessageEntity method
           let messageEntities = self.messages.map { message in
               let messageEntity = message.toMessageEntity(context: context)
               messageEntity.conversation = entity
               return messageEntity
           }
           
        entity.messages = NSSet(array: messageEntities) as? Set<MessageEntity>
           
           return entity
       }
}

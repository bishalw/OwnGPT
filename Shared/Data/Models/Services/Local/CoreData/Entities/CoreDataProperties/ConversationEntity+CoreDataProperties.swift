//
//  ConversationEntity+CoreDataProperties.swift
//  OwnGpt
//
//  Created by Bishalw on 8/29/23.
//
//

import Foundation
import CoreData


extension ConversationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversationEntity> {
        return NSFetchRequest<ConversationEntity>(entityName: "ConversationEntity")
    }
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var messages: Set<MessageEntity>?
    @NSManaged public var updatedAt: Date?
    

}
// MARK: computed properties for NSManaged
extension ConversationEntity  {
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedMessages: Set<MessageEntity> {
        messages ?? []
    }
    
}
// MARK: Generated accessors for messages

    
    
extension ConversationEntity {
    func toConversation() -> Conversation? {
        guard let id = self.id else { return nil }
        
        let sortedMessages = self.wrappedMessages.sorted {
            ($0.createdAt ?? Date.distantPast) < ($1.createdAt ?? Date.distantPast)
        }
        
        let messageList = sortedMessages.compactMap { $0.toDomainModel() }
        
        var conversation = Conversation(id: id, messages: messageList)
        conversation.createdAt = self.createdAt ?? Date()
        conversation.updatedAt = self.updatedAt ?? Date()
        return conversation
    }
    func update(with conversation: Conversation, in context: NSManagedObjectContext) {
            self.updatedAt = Date()
            
            // Update existing messages and add new ones
            let existingMessages = self.wrappedMessages
            for message in conversation.messages {
                if let existingMessage = existingMessages.first(where: { $0.id == message.id }) {
                    existingMessage.update(with: message)
                } else {
                    let newMessageEntity = message.toMessageEntity(context: context)
                    newMessageEntity.conversation = self
                    self.messages?.insert(newMessageEntity)
                }
            }
            
            // Remove messages that are no longer in the conversation
            let messagesToRemove = existingMessages.filter { messageEntity in
                !conversation.messages.contains { $0.id == messageEntity.id }
            }
            for messageToRemove in messagesToRemove {
                self.messages?.remove(messageToRemove)
                context.delete(messageToRemove)
        }
    }
}


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
    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID?
    @NSManaged public var messages: NSSet?
    @NSManaged public var updatedAt: Date?
    

}
// MARK: computed properties for NSManaged
extension ConversationEntity  {
    public var wrappedId: UUID {
        id ?? UUID()
    }
//    public var wrappedUpdatedAt: Date {
//        updatedAt ?? Date()
//    }
    
}
class AttributeChcker {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
// MARK: Generated accessors for messages
extension ConversationEntity {
    func toConversation() -> Conversation? {
        
        guard let id = self.id else {
            Log.shared.logger.error("ConversationEntity conversion failed: missing id")
            return nil
        }
        
        let messageList: [Message]
        
        if let messageSet = self.messages as? Set<MessageEntity> {
            
            messageSet.forEach { _ = $0.contentString }
            
            messageList = messageSet.compactMap { messageEntity -> Message? in
                return messageEntity.toDomainModel()
            }
            if messageList.count != messageSet.count {
                Log.shared.logger.warn("Some messages failed to convert: \(messageSet.count - messageList.count) failures")
            }
        } else {
            Log.shared.logger.warn("Messages set is nil or not a Set<MessageEntity>")
            messageList = []
        }
        
        let conversation = Conversation(id: id, messages: messageList)
        return conversation
    }
}


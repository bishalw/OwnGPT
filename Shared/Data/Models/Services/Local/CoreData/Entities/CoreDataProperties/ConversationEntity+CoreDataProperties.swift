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
class AttributeChcker {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
// MARK: Generated accessors for messages

    
    
extension ConversationEntity {
    func toConversation() -> Conversation? {
        let id = self.wrappedId
        let messageList = self.wrappedMessages.compactMap { $0.toDomainModel() }
        return Conversation(id: id, messages: messageList)
    }
}



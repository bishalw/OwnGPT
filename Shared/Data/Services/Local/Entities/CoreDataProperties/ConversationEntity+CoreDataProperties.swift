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

    @NSManaged public var id: UUID?
    @NSManaged public var messages: NSSet?

}
// MARK: computed properties for NSManaged
extension ConversationEntity  {
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
}
// MARK: Generated accessors for messages
extension ConversationEntity {
    func toConversation() -> Conversation? {
//        Log.shared.info("Starting toConversation() conversion for ConversationEntity: \(self)")
        
        guard let id = self.id else {
            Log.shared.logger.error("ConversationEntity conversion failed: missing id")
            return nil
        }
//        Log.shared.info("ID: \(id)")
        
        let messageList: [Message]
        
        if let messageSet = self.messages as? Set<MessageEntity> {
//            Log.shared.info("Number of messages: \(messageSet.count)")
            
            // Prefetch message data to avoid individual fault firings
            messageSet.forEach { _ = $0.contentString }
            
            messageList = messageSet.compactMap { messageEntity -> Message? in
//                Log.shared.info("Processing MessageEntity: \(messageEntity)")
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
//        Log.shared.info("Finished toConversation() conversion. Conversation: \(conversation)")
        return conversation
    }
}

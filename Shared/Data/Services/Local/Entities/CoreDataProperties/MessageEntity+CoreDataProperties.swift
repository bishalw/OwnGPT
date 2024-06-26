//
//  MessageEntity+CoreDataProperties.swift
//  OwnGpt
//
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var contentString: String?
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var conversation: ConversationEntity?
    
}
extension MessageEntity {
    // ... existing code ...

    func toDomainModel() -> Message? {
        guard let id = self.id else {
            Log.shared.error("MessageEntity conversion failed: missing id")
            return nil
        }
        guard let typeString = self.type else {
            Log.shared.error("MessageEntity conversion failed: missing type")
            return nil
        }
        guard let messageType = Message.MessageType(rawValue: typeString) else {
            Log.shared.error("MessageEntity conversion failed: invalid type \(typeString)")
            return nil
        }
        guard let content = self.toDomainContent() else {
            Log.shared.error("MessageEntity conversion failed: missing content")
            return nil
        }
        
        let message = Message(id: id, type: messageType, content: content, isStreaming: false)
        return message
    }
    
    private func toDomainContent() -> Message.ContentType? {
        guard let contentString = self.contentString else {
            Log.shared.error("MessageEntity conversion failed: missing contentString")
            return nil
        }
        
        return .message(string: contentString)
    }
}

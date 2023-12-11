//
//  MessageEntity+CoreDataProperties.swift
//  OwnGpt
//
//  Created by Bishalw on 8/29/23.
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
extension MessageEntity : Identifiable {
    func toDomainModel() -> Message? {
        guard let id = self.id,
              let typeString = self.type,
              let messageType = Message.MessageType(rawValue: typeString),
              let contentType = self.toDomainContentType() else {
            return nil // Handle the error appropriately
        }
        // Use `toDomainContentType()` to get the content
        let message = Message(id: id, type: messageType, content: contentType, isStreaming: true)
        return message
    }
    
    func toDomainContentType() -> Message.ContentType? {
        if let messageString = self.contentString {
            return .message(string: messageString)
        }
        return nil
    }
 
}

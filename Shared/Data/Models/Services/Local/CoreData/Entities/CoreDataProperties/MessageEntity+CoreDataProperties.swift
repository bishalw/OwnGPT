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
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var conversation: ConversationEntity?
    
}

extension MessageEntity {
    func toDomainModel() -> Message? {
          guard let id = self.id,
                let typeString = self.type,
                let messageType = Message.MessageType(rawValue: typeString),
                let content = self.toDomainContent(),
                let createdAt = self.createdAt else {
              return nil
          }
          
          return Message(id: id, type: messageType, content: content, isStreaming: false, createdAt: createdAt)
      }
    
    private func toDomainContent() -> Message.ContentType? {
        guard let contentString = self.contentString else {
            return nil
        }
        
        return .message(string: contentString)
    }
    func update(with message: Message) {
            self.id = message.id
            self.type = message.type.rawValue
            self.contentString = message.content.text
            self.createdAt = message.createdAt
        }
}

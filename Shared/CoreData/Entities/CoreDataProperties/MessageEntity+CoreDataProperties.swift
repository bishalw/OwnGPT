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

}

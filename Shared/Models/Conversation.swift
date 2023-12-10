//
//  Conversation.swift
//  OwnGpt
//
//  Created by Bishalw on 8/28/23.
//

import Foundation

struct Conversation: Identifiable {
    var id: UUID
    var messages: [Message]

    init(id: UUID, messages: [Message]) {
       self.id = id
       self.messages = messages
    }
}

extension Conversation {
    static func from(entity: ConversationEntity) -> Conversation {
        let messageEntities = entity.messages?.allObjects as? [MessageEntity] ?? []
        let messages = messageEntities.compactMap { Message.from(entity: $0) }
        return Conversation(id: entity.wrappedId, messages: messages)
    }
}



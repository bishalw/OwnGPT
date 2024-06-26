//
//  ChatRow.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI
import CoreData

// MARK: Swift Type
struct Message: Identifiable {
    var id: UUID
    var type: MessageType
    var content: ContentType
    var isStreaming: Bool

    enum MessageType: String, Equatable {
        case system, user
    }
    
    enum ContentType {
        case message(string: String)
        case error(error: Error)
    }
}

extension Message {
    var defaultIconName: String {
        switch self.type {
        case .system: return "volleyball.circle.fill"
        case .user: return "person.fill"
        }
    }
    // MARK: - Message to OpenAIModels(Message)
    var toOpenAiMessage: OpenAiModels.Message {
        return OpenAiModels.Message(role: self.type.rawValue, content: self.content.text)
    }
}

extension Message.ContentType: Equatable {
    
    var text: String {
        switch self {
        case .message(let string):
            return string
        case .error(let error):
            return error.localizedDescription
        }
    }
    static func ==(lhs: Message.ContentType, rhs: Message.ContentType) -> Bool {
        switch (lhs, rhs) {
        case let (.message(string: lhsString), .message(string: rhsString)):
            return lhsString == rhsString
        case let (.error(error: lhsError), .error(error: rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
   
}

extension Message {
    
    init(from openAiMessage: OpenAiModels.Message) {
        self.id = UUID()
        switch openAiMessage.role {
        case "user":
            self.type = .user
        case "system":
            self.type = .system
        default:
            self.type = .system
        }
        self.content = .message(string: openAiMessage.content)
        self.isStreaming = true 
    }
    
    
}

extension Message {
    func toMessageEntity(context: NSManagedObjectContext) -> MessageEntity {
        let messageEntity = MessageEntity(context: context)
        messageEntity.id = self.id
        messageEntity.type = self.type.rawValue
        switch self.content {
        case .message(let string):
            messageEntity.contentString = string
        case .error(let error):
            messageEntity.contentString = error.localizedDescription
        }
        return messageEntity
    }
}





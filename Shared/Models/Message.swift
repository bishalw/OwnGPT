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
        case .system: return "brain.fill"
        case .user: return "person.fill"
        }
    }
    
    var toOpenAiMessage: OpenAiModels.Message {
        return OpenAiModels.Message(role: self.type.rawValue, content: self.content.text)
    }
}

extension Message {
    static func from(entity: MessageEntity) -> Message? {
        guard let id = entity.id,
              let typeString = entity.type,
              let type = MessageType(rawValue: typeString),
              let content = entity.contentString else { return nil }
        return Message(
            id: id,
            type: type,
            content: .message(string: content),
            isStreaming: false
        )
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
    static func from(entity: MessageEntity) -> Message.ContentType? {
        guard let message = entity.contentString else { return nil }
        return .message(string: message)
    }
}
extension Message {
    init(from openAiMessage: OpenAiModels.Message) {
        self.id = UUID()
        switch openAiMessage.role {
        case "user":
            self.type = .user
        case "system", "assistant": // Assuming 'system' or 'assistant' role indicates a system message
            self.type = .system
        default:
            self.type = .system // Or handle default case appropriately
        }
        self.content = .message(string: openAiMessage.content)
        self.isStreaming = true // Set to true if applicable
    }
}






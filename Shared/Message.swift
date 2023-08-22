//
//  ChatRow.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI


struct Message: Identifiable {
    var id: UUID
    var type: MessageType
    var content: ContentType
    var isStreaming: Bool

    enum MessageType: Equatable {
        case system, user
    }
    
    enum ContentType: Equatable {
        case message(string: String)
        case error(error: Error)
        
        var text: String {
            switch self {
            case .message(let string):
                return string
            case .error(let error):
                return error.localizedDescription
            }
        }
        
        static func ==(lhs: ContentType, rhs: ContentType) -> Bool {
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

}

extension Message {
    var defaultIconName: String {
        switch self.type {
        case .system: return "brain.fill"
        case .user: return "person.fill"
        }
    }
    
    var toOpenAiMessage: OpenAiModels.Message {
        return OpenAiModels.Message(role: self.type.toString(), content: self.content.text)
    }
    
}

extension Message.MessageType {
    func toString() -> String {
        switch self {
        case .user: return "user"
        case .system: return "system"
        }
    }
}


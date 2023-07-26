//
//  CompletionResponse.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import Foundation


struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Choice: Decodable{
    let message: Message
    let finishReason: StreamChoice
    
}
struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}
struct Message: Codable {
    let role: String
    let content: String
}
struct Request: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    let stream: Bool
}

struct ErrorRootReponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

// Stream Model

struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}
struct StreamChoice: Decodable {
    let finishReason: String?
    let delta: StreamMessage
}
struct StreamMessage: Decodable {
    let content: String?
}
extension Array where Element == Message {
    
    var contentCount: Int { reduce (0, {$0 + $1.content.count})}
    
}

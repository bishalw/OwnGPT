//
//  CompletionResponse.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import Foundation

struct CompletionResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable{
    let index: Int
    let message: [Message]
    let finish_reason: String
    
}

struct Message: Codable {
    let role: String
    let content: String
}

extension Array where Element == Message {
    
    var contentCount: Int { reduce (0, {$0 + $1.content.count})}
    
}

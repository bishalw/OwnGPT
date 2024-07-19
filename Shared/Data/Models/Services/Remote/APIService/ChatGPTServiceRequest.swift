//
//  ChatGPTServiceRequest.swift
//  OwnGpt
//

//

import Foundation
import Bkit

struct ChatGPTServiceRequest: HTTPRequest {
    
    var scheme: String {
        return "https"
    }
    var host: String = "api.openai.com"
    
    var path: String = "/v1/chat/completions"
    
    var headers: [String : String]?
    
    var body: Data?
    
    var method: HTTPRequestType = .post
    
    var parameters: [String : String]?
    
    init(apiKey: String) {
        self.headers =
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
    
}

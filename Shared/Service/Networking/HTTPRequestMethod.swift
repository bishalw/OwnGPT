//
//  HTTPMethod.swift
//  OwnGpt
//
//  Created by Bishalw on 1/6/24.
//

import Foundation

public enum HTTPRequestMethod {
    case get
    case post
    case put
    case delete
    
    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

//
//  DataParser.swift
//  OwnGpt
//
//  Created by Bishalw on 1/6/24.
//

import Foundation

public protocol DataParser {
    func decode<T: Decodable>(_type: T.Type, from data: Data) throws -> T
}


public struct DataParserImpl: DataParser {
    let jsonDecoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = decoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func decode<T: Decodable>(_type : T.Type, from data: Data) throws -> T {
            do {
                let decodedObject = try jsonDecoder.decode(T.self, from: data)
                return decodedObject
            } catch {
                throw error
            }
        }
}



//
//  NetworkService.swift
//  OwnGpt
//
//  Created by Bishalw on 1/6/24.
//

import Foundation
import os

public protocol NetworkStreamingService {
    
    func makeStreamingRequest<T: Decodable, U>(
        request: any HTTPRequest,
        responseModel: T.Type,
        dataPrefix: String?,
        transform: @escaping (T) -> U?
    ) async throws -> AsyncThrowingStream<U, Error>
}
public protocol NetworkService {
    func sendRequest<T: Decodable>(request: any HTTPRequest, responseModel: T.Type) async throws -> T
}





//
//  NetworkService.swift
//  OwnGpt
//
//  Created by Bishalw on 1/6/24.
//

import Foundation


public protocol NetworkStreamingService {
    func makeStreamingRequest<T: Decodable>(request: any HTTPRequest, responseModel: T.Type, dataPrefix: String?) async throws -> AsyncThrowingStream<T,Error>
}

public class NetworkServiceImpl: NetworkStreamingService {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func makeStreamingRequest<T: Decodable>(request: any HTTPRequest, responseModel: T.Type, dataPrefix: String? = nil) async throws -> AsyncThrowingStream<T, Error> {
       
        let url = try createURL(from: request)
        let urlRequest = createURLRequest(url: url, method: request.method, headers: request.headers, body: request.body)

        // Debugging: Log the final request body
        if let bodyData = urlRequest.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }

        let (bytes, response) = try await self.urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(url: urlRequest)
        }

        if !(200...299).contains(httpResponse.statusCode) {
            var responseBody = ""
            do {
                for try await line in bytes.lines {
                    responseBody.append(line)
                }
            } catch {
                throw error
            }
            throw NetworkError.badResponse(url: url, statusCode: httpResponse.statusCode, body: responseBody)
        }

        return AsyncThrowingStream<T, Error> { continuation in
            Task(priority: .userInitiated) {
                do {
                    for try await line in bytes.lines {
                        if line.hasPrefix(dataPrefix ?? ""),
                           let data = line.dropFirst(dataPrefix?.count ?? 0).data(using: .utf8) {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            continuation.yield(decodedObject)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    private func createURLRequest(url: URL, method: HTTPRequestType, headers: [String: String]?, body: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = body
        return urlRequest
    }

    private func createURL(from request: HTTPRequest) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse(url: URLRequest?)
    case badResponse(url: URL?, statusCode: Int, body: String)
    case other(url: URL?, underlyingError: Error)
}

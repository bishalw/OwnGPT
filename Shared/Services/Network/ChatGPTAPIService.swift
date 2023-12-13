//
//  ChatGPTAPI.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import Foundation

class ChatGPTAPIService {
    
    private let temperature: Double
    private let model: String
    private let apiKey: String

    private let systemMessage: OpenAiModels.Message
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        headers.forEach { headerField, headerValue in
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        return urlRequest
    }
    private var headers: [String: String] {
        [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(apiKey)"
        ]
    }
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    init(apiKey: String, model: String = "gpt-3.5-turbo",systemPrompt: String = "You are a helpful assistant", temperature: Double = 0.5) {
        self.apiKey = apiKey
        self.model = model
        self.temperature = temperature
        self.systemMessage = .init(role: "system", content: systemPrompt)
    }
    
    
    enum ChatGPTAPIError: Error {
        case invalidResponse
        case badResponse(statusCode: Int)
        case other(Error)
        
        var localizedDescription: String {
            switch self {
            case .invalidResponse:
                return "Invalid response from the server."
            case .badResponse(let statusCode):
                return "Bad response from the server with status code \(statusCode)."
            case .other(let error):
                return error.localizedDescription
            }
        }
    }
    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, history: history)
        let (result, response) = try await urlSession.bytes(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ChatGPTAPIError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw ChatGPTAPIError.badResponse(statusCode: httpResponse.statusCode)
        }

        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) {
                do {
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8) {
                            if let response = try? self.jsonDecoder.decode(OpenAiModels.StreamCompletionResponse.self, from: data),
                               let content = response.choices.first?.delta.content {
                                continuation.yield(content)
                            }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
   
    private func jsonBody(text: String, history: [OpenAiModels.Message], stream: Bool = true) throws -> Data {
        var messages = history
        let newUserMessage = OpenAiModels.Message(role: "user", content: text)
        messages.append(newUserMessage) // Add the new user message
        let request = OpenAiModels.Request(model: model, messages: messages, temperature: temperature, stream: stream)
        let requestBody = try JSONEncoder().encode(request)
        print("Request Body: \(String(data: requestBody, encoding: .utf8) ?? "")")
        return requestBody
    }
    

  
}
extension String: Error {}


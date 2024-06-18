//
//  ChatGPTAPI.swift
//  OwnGpt
//
//

import Foundation

protocol ChatGPTAPIService {
    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> 
}
class ChatGPTAPIServiceImpl: ChatGPTAPIService {
    
    private let temperature: Double
    private let model: String
    private let systemMessage: OpenAiModels.Message
    private let urlSession = URLSession.shared
    private let networkService: NetworkStreamingService
    private let jsonDecoder: JSONDecoder
    private let apiKey: String
    

    
    init(
        model: String = "gpt-3.5-turbo",
        temperature: Double = 0.7,
        systemPrompt: String = "You are a helpful assistant",
        networkService: NetworkStreamingService,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        apiKey: String
        
    ) {
        self.apiKey = apiKey
        self.model = model
        self.temperature = temperature
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.networkService = networkService
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
    }
    
    
    enum ChatGPTAPIError: Error {
        case networkError(NetworkError)
        case decodingError(Error)
        case apiError(statusCode: Int, message: String)
        case unknownError(Error)

        var localizedDescription: String {
            switch self {
                case .networkError(let networkError):
                    return "Network error occurred: \(networkError.localizedDescription)"
                case .decodingError(let error):
                    return "Failed to decode the response: \(error.localizedDescription)"
                case .apiError(let statusCode, let message):
                    return "API error \(statusCode): \(message)"
                case .unknownError(let error):
                    return "An unknown error occurred: \(error.localizedDescription)"
            }
        }
    }

    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> {
        
        var serviceRequest = ChatGPTServiceRequest(apiKey: self.apiKey)
        serviceRequest.body = try jsonBody(text: text, history: history)

        
        let responseStream = try await networkService.makeStreamingRequest(request: serviceRequest, responseModel: OpenAiModels.StreamCompletionResponse.self, dataPrefix: "data: ")
        return AsyncThrowingStream<String, Error> { continuation in
                Task {
                    do {
                        for try await completionResponse in responseStream {
                            print("Debug - Completion Response: \(completionResponse)")
                            for choice in completionResponse.choices {
                                if let content = choice.delta.content {
                                    print("Debug - Content Received: \(content)")
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
        messages.append(newUserMessage)
        let request = OpenAiModels.Request(model: model, messages: messages, temperature: temperature, stream: stream)
        let requestBody = try JSONEncoder().encode(request)
        print("Request Body: \(String(data: requestBody, encoding: .utf8) ?? "")")
        return requestBody
    }
}
extension String: Error {}


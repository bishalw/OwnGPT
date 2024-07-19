//
//  ChatGPTAPI.swift
//  OwnGpt
//
//

import Foundation
import Bkit

protocol ChatGPTAPIService {
    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> 
}


class ChatGPTAPIServiceImpl: ChatGPTAPIService {
    
    private let temperature: Double
    private let model: String
    private let systemMessage: OpenAiModels.Message
    private let urlSession = URLSession.shared
    private let networkService: NetworkStreamingService
    private let apiKey: String
    
    init(
        model: String = "gpt-3.5-turbo",
        temperature: Double = 0.7,
        systemPrompt: String = "You are a helpful assistant",
        networkService: NetworkStreamingService,
        apiKey: String
    ) {
        self.apiKey = apiKey
        self.model = model
        self.temperature = temperature
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.networkService = networkService
        
    }
    
    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> {
        var serviceRequest = ChatGPTServiceRequest(apiKey: apiKey)
        serviceRequest.body = try jsonBody(text: text, history: history)
        return try await networkService.makeStreamingRequest(
            request: serviceRequest,
            responseModel: OpenAiModels.StreamCompletionResponse.self,
            dataPrefix: "data: "
        ) { response in
            response.choices.first?.delta.content
        }
    }
    
    private func jsonBody(text: String, history: [OpenAiModels.Message], stream: Bool = true) throws -> Data {
        var messages = history
        messages.append(OpenAiModels.Message(role: "user", content: text))
        let request = OpenAiModels.Request(model: model, messages: messages, temperature: temperature, stream: stream)
        return try JSONEncoder().encode(request)
    }
    
}

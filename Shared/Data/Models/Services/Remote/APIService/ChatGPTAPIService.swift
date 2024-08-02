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
    private let networkService: NetworkStreamingService
    private let apiKey: String
    private let openAIConfigStore: OpenAIConfigStore
    
    init(
        systemPrompt: String = "You are a helpful assistant",
        networkService: NetworkStreamingService,
        apiKey: String,
        openAIConfigStore: OpenAIConfigStore
    ) {
        self.apiKey = apiKey
        self.openAIConfigStore = openAIConfigStore
        self.model = openAIConfigStore.openAILMConfig.model.modelName
        self.temperature = openAIConfigStore.openAILMConfig.temperature.rounded()
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

//
//  ChatGPTAPI.swift
//  OwnGpt
//
//

import Foundation
import Bkit
import Combine


protocol ChatGPTAPIService {
    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> 
}


class ChatGPTAPIServiceImpl: ChatGPTAPIService {
    
    private let systemMessage: OpenAiModels.Message
    private let networkService: NetworkStreamingService
    private var apiKey: String = ""
    private let openAIConfigStore: OpenAIConfigStore
    private var config: OpenAILMConfig
    private var cancellables: Set<AnyCancellable> = []
    init(
        systemPrompt: String = "You are a helpful assistant",
        networkService: NetworkStreamingService,
        openAIConfigStore: OpenAIConfigStore
    ) {
        self.openAIConfigStore = openAIConfigStore
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.networkService = networkService
        self.config = openAIConfigStore.openAILMConfig

        setupSubscriptions()
    }
    private func setupSubscriptions(){
        openAIConfigStore.openAILMConfigPublisher
                   .sink { [weak self] config in
                       self?.config = config
                   }
                   .store(in: &cancellables)
               
               openAIConfigStore.openAIKeyPublisher
                   .sink { [weak self] key in
                       self?.apiKey = key
                   }
                   .store(in: &cancellables)
    }
    
    func sendMessageStream(text: String, history: [OpenAiModels.Message]) async throws -> AsyncThrowingStream<String, Error> {
        var serviceRequest = ChatGPTServiceRequest(apiKey: apiKey)
        serviceRequest.body = try jsonBody(text: text, history: history)
        Log.shared.logger.info("Request Body: \(String(data: serviceRequest.body ?? Data(), encoding: .utf8) ?? "N/A")")
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
        let request = OpenAiModels.Request(
            model: openAIConfigStore.openAILMConfig.model.modelName,
            messages: messages,
            temperature: openAIConfigStore.openAILMConfig.temperature,
            stream: stream)
        return try JSONEncoder().encode(request)
    }
    
}

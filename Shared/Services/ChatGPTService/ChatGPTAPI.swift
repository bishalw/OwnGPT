//
//  ChatGPTAPI.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import Foundation

class ChatGPTAPI {
    
    private let systemMessage: OpenAiModels.Message
    private let temperature: Double
    private let model: String
    private let apiKey: String
    
//    var historyList = [OpenAiModels.Message]()
    
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
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.temperature = temperature
    }
    
//    func getHistoryList() -> [OpenAiModels.Message] {
//        return self.historyList
//    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid Response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw "Bad Response: \(httpResponse.statusCode)"
        }
        let stream = AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(OpenAiModels.StreamCompletionResponse.self, from: data),
                           let text = response.choices.first?.delta.content {
                            responseText += text
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
        
        return stream
    }
    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        guard 200...299 ~= httpResponse.statusCode else {
            throw "Bad response: \(httpResponse.statusCode)"
        }
        
        do {
            let completionResponse = try self.jsonDecoder.decode(OpenAiModels.CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.message.content ?? ""
            self.appendToHistoryList(userText: text, responseText: responseText)
            return responseText
        } catch {
            throw error
        }
    }
    private func appendToHistoryList(userText: String, responseText: String) {
        self.historyList.append(.init(role:"user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }
    
    private func generateMessages(from text: String) -> [OpenAiModels.Message] {
        var messages = [systemMessage] + historyList + [OpenAiModels.Message(role: "user", content: text)]
        
        if messages.contentCount > (4000 * 4) {
            _ = historyList.dropFirst()
            messages = generateMessages(from: text)
        }
        return messages
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = OpenAiModels.Request(model: model, messages: generateMessages(from: text),
                              temperature: temperature, stream: stream)
        return try JSONEncoder().encode(request)
    }
    
    func deleteHistoryList(){
        self.historyList.removeAll()
    }
}
extension String: Error {}
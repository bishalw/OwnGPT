//
//  OpenAIConfig.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/24.
//

import Foundation

struct OpenAIConfig: ServiceProvider, Codable {
    var modelConfig: OpenAILMConfig
    var apiKey: APIKey
    
    init(modelConfig: OpenAILMConfig = OpenAILMConfig(),
         apiKey: APIKey = APIKey(serviceKey: .openAI, value: "")
    ) {
            self.modelConfig = modelConfig
            self.apiKey = apiKey
    }
}




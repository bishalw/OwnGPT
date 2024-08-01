//
//  AnthropicConfigurationViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Foundation
import Combine

protocol AnthropicConfigurationViewModel: ConfigurationViewModel {
    var modelAIConfig: AnthropicLMConfig { get set }
    var selectedModel: AnthropicModelType { get set }
}

class AnthropicConfigurationViewModelImpl: AnthropicConfigurationViewModel {
    
    @Published var modelAIConfig: AnthropicLMConfig = .init()
    @Published var apiKey: String = ""
    
    var selectedModel: AnthropicModelType {
        get { modelAIConfig.model }
        set { modelAIConfig.model = newValue}
    }
    
    var contextWindowSize: Int {
        get { modelAIConfig.contextWindowSize }
        set { modelAIConfig.contextWindowSize = newValue }
    }
        
    
    var temperature: Double {
        get { modelAIConfig.temperature }
        set { modelAIConfig.temperature = newValue }
    }

    private var cancellables = Set<AnyCancellable>()
    private let anthropicConfigStore: AnthropicConfigStore
    var didsave: () -> Void
    init (
        anthropicConfigStore: AnthropicConfigStore,
        didsave: @escaping () -> Void = {}
    ) {
        self.didsave = didsave
        self.anthropicConfigStore = anthropicConfigStore
    }
    private func setupBindings() {
        
    }
    func save() {
        
    }
    
}

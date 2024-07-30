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
        
    
//    private let configStore: any ConfigurationStore
    private var cancellables = Set<AnyCancellable>()
    var didsave: () -> Void
    init (
//        configStore: any ConfigurationStore,
        didsave: @escaping () -> Void = {}
    ) {
//        self.configStore = configStore
        self.didsave = didsave
//        setupBindings()
    }
    private func setupBindings() {
        
//        configStore.apiKeyPublisher
//            .map { $0?.value ?? "" }
//            .assign(to: \.apiKey, on: self)
//            .store(in: &cancellables)
    }
    func save() {
        
    }
    
}

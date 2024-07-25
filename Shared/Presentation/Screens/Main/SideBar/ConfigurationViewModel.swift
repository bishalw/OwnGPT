//
//  SettingsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import Foundation
import Combine

protocol ConfigurationViewModel: ObservableObject {
    var apiKey: String { get set }
    var contextWindowSize: Int { get set }
    var temperature: Double { get set}
    func save()
}
protocol OpenAIConfigurationViewModel: ConfigurationViewModel{
    var modelAIConfig: OpenAILMConfig { get set }
    var selectedModel: OpenAIModelType { get set }
}

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
        
    
    private let configStore: any ConfigurationStore
    private var cancellables = Set<AnyCancellable>()
    var didsave: () -> Void
    init (
        configStore: any ConfigurationStore,
        didsave: @escaping () -> Void = {}
    ) {
        self.configStore = configStore
        self.didsave = didsave
        setupBindings()
    }
    private func setupBindings() {
        
        configStore.apiKeyPublisher
            .map { $0?.value ?? "" }
            .assign(to: \.apiKey, on: self)
            .store(in: &cancellables)
    }
    func save() {
        
    }
    
}

class OpenAIConfigViewModelImpl: OpenAIConfigurationViewModel {

    @Published var modelAIConfig: OpenAILMConfig = .init()
    @Published var apiKey: String = ""
    
   
    var contextWindowSize: Int {
        get { modelAIConfig.contextWindowSize }
        set { modelAIConfig.contextWindowSize = newValue }
    }
    
    var temperature: Double {
        get { modelAIConfig.temperature }
        set { modelAIConfig.temperature = newValue }
    }
    var selectedModel: OpenAIModelType {
        get { modelAIConfig.model }
        set { modelAIConfig.model = newValue}
    }
    var didsave: () -> Void
    
    private let configStore: any ConfigurationStore
    private var cancellables = Set<AnyCancellable>()
    
    init (
        configStore: any ConfigurationStore,
        didsave: @escaping () -> Void = {}
    ) {
        self.configStore = configStore
        self.didsave = didsave
        setupBindings()
    }
    
    private func setupBindings() {
        
        configStore.apiKeyPublisher
            .map { $0?.value ?? "" }
            .assign(to: \.apiKey, on: self)
            .store(in: &cancellables)
    }
    
    func save() {
        didsave()
    }
}

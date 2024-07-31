//
//  OpenAIConfigurationViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
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
class OpenAIConfigurationViewModelImpl: OpenAIConfigurationViewModel {

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
    
    private let openAIConfigStore: OpenAiConfigStore
    private var cancellables = Set<AnyCancellable>()
    
    init (
        openAIConfigStore: OpenAiConfigStore,
        didsave: @escaping () -> Void = {}
    ) {
        self.openAIConfigStore = openAIConfigStore
        self.didsave = didsave
        setupBindings()
    }
    
    private func setupBindings() {

    }
    
    func save() {
        didsave()
    }
}

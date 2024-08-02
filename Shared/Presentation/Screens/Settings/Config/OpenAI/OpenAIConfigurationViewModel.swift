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
    func fetchOpenAPIKey() async
    func setOpenAPIKey() async

}
class OpenAIConfigurationViewModelImpl: OpenAIConfigurationViewModel {
    @Published var modelAIConfig: OpenAILMConfig
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
        set { modelAIConfig.model = newValue }
    }
    
    var didsave: () -> Void
    
    private var openAIConfigStore: OpenAIConfigStore
    private var cancellables = Set<AnyCancellable>()
    
    init(
        openAIConfigStore: OpenAIConfigStore,
        didsave: @escaping () -> Void = {}
    ) {
        self.openAIConfigStore = openAIConfigStore
        self.didsave = didsave
        Log.shared.logger.info("VM initialized")
        self.modelAIConfig = openAIConfigStore.openAILMConfig
        setupBindings()
        Task {
            await fetchOpenAPIKey()
        }
    }

    private func setupBindings() {
        openAIConfigStore.openAILMConfigPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newConfig in
                self?.modelAIConfig = newConfig
            }
            .store(in: &cancellables)
        
        openAIConfigStore.openAIKeyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                Log.shared.logger.info("Received new API key value: \(newValue)")
                self?.apiKey = newValue
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func save() {
        openAIConfigStore.openAILMConfig = modelAIConfig
        didsave()
    }
    
    @MainActor
    func fetchOpenAPIKey() async {
        apiKey = await openAIConfigStore.getValueForKey()
        Log.shared.logger.info("Fetched API key: \(apiKey)")
    }

    @MainActor
    func setOpenAPIKey() async {
        Log.shared.logger.info("Setting API key: \(apiKey)")
        await openAIConfigStore.setKey(apiKey)
    }
}

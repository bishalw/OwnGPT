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
        Task {
            func fetchOpenAPIKey() async {
                apiKey = await openAIConfigStore.fetchOpenAPIKey()
                print("Fetched API key: \(apiKey)")
            }
        }
       
    }
    private func setupBindings() {
        openAIConfigStore.openAIKeyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                print("Received new API key value: \(newValue)")
                self?.apiKey = newValue
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchOpenAPIKey() async {
        apiKey = await openAIConfigStore.fetchOpenAPIKey()
        Log.shared.logger.info("Fetched API key: \(apiKey)")
    }

@MainActor
func setOpenAPIKey() async  {
    Log.shared.logger.info("Setting API key: \(apiKey)")
         await openAIConfigStore.setOpenAPIKey(apiKey)
}
    func save() {
        didsave()
        
    }
}

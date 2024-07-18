//
//  SettingsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var apiKey: String = ""
    @Published var selectedModel: ChatGPTModel = .gpt3_5
    @Published var temperature: Double = 0.7
    @Published var contextWindowSize: Int = 5
    
    init(){
        
    }
    
    
}

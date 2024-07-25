//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Bkit

protocol UserDefaultsStore: ObservableObject {
    var hasOnboarded: PublishedAppStorage<Bool> { get set }
    func clearCache()
}
class UserDefaultsStoreImpl: UserDefaultsStore {

    @PublishedAppStorage("hasOnboarded") var internalHasOnboarded: Bool = false
    @PublishedAppStorage("openAIConfig") var openAIConfig: OpenAILMConfig = .init()
    
    var hasOnboarded: PublishedAppStorage<Bool> {
        get { self._internalHasOnboarded }
        set { self._internalHasOnboarded = newValue }
    }
     
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: "hasOnboarded")
    }
}



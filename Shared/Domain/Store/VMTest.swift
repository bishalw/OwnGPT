//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Bkit
import Combine

protocol UserDefaultsStore: ObservableObject {
    
    func clearCache()
    
}


//class UserDefaultsStoreImpl: UserDefaultsStore {
//    
//    @PublishedAppStorage("hasOnboarded") var internalHasOnboarded: Bool = false
//    @PublishedAppStorage( "openAIConfig", store: UserDefaults.standard)  var openAIConfig : OpenAILMConfig = .init()
//    
//     let userDefaultsPublisher: any PublishingUserDefaultsService
//    
//        var hasOnboarded: PublishedAppStorage<Bool> {
//            get { self._internalHasOnboarded }
//            set { self._internalHasOnboarded = newValue }
//        }
//    
//    
//    
//    
//    init(userDefaultsPublisher: any PublishingUserDefaultsService) {
//        self.userDefaultsPublisher = userDefaultsPublisher
//        
//    }
//    func clearCache() {
//        
//    }
//        func add(type: Any) {
//            UserDefaults.standard.set(type, forKey: "test")
//            
//        }
//        func get(key: String) {
//            UserDefaults.standard.object(forKey: key)
//        }
//    
//}



//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Bkit

class UserDefaultsStore: ObservableObject{
    @PublishedAppStorage("hasOnboarded") var hasOnboarded: Bool = false
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: "hasOnboarded")
    }
}



//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Bkit
import Combine

protocol UserDefaultsStore {
    var hasUserOnboardedPublisher: AnyPublisher<Bool, Never> { get }
    var hasOnboarded: Bool { get set }
}

class UserDefaultsStoreImpl: UserDefaultsStore {

    var hasOnboarded: Bool {
        get {
            self.observableUserDefaultService.get(forKey: userDefaultsKey.hasOnboarded.rawValue) ?? false
        }
        set {
            self.observableUserDefaultService.set(value: newValue, forKey: userDefaultsKey.hasOnboarded.rawValue)
        }
    }
    var hasUserOnboardedPublisher: AnyPublisher<Bool, Never> {
        return self.observableUserDefaultService.userDefaultsPublisher(forKey: userDefaultsKey.hasOnboarded.rawValue, defaultValue: false)
    }
    // MARK: Dependency
    private let observableUserDefaultService: ObservableUserDefaultService
    
    init(observableUserDefaultService: ObservableUserDefaultService) {
        self.observableUserDefaultService = observableUserDefaultService
    }
}



//
//  MockUserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/8/24.
//

import Foundation
import Combine


class MockUserDefaultsStore: UserDefaultsStore {
    var hasOnboardedValue: Bool = false
    private let hasOnboardedSubject = CurrentValueSubject<Bool, Never>(false)
    
    var hasOnboarded: Bool {
        get {
            return hasOnboardedValue
        }
        set {
            hasOnboardedValue = newValue
            hasOnboardedSubject.send(newValue)
        }
    }
    
    var hasUserOnboardedPublisher: AnyPublisher<Bool, Never> {
        return hasOnboardedSubject.eraseToAnyPublisher()
    }
    
    func setHasOnboarded(_ value: Bool) {
        hasOnboarded = value
    }
}

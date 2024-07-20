//
//  UserDefaultsStore.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Combine
import SwiftUI

class UserDefaultsStore: ObservableObject {
    
    @AppStorage("hasOnboarded") private var _hasOnboarded = false
    var hasOnboarded: Bool {
        get { self._hasOnboarded }
        set { self._hasOnboarded = newValue
            self.hasOnboardedCurrentValueSubject.value = newValue
        }
    }
    private lazy var hasOnboardedCurrentValueSubject = CurrentValueSubject<Bool, Never>(hasOnboarded)
    
    var hasOnboardedDidChange: AnyPublisher<Bool, Never> {
        return hasOnboardedCurrentValueSubject.eraseToAnyPublisher()
    }
}

class ConfigStore: ObservableObject {
    
}

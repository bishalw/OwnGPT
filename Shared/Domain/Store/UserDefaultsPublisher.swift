//
//  UserDefaultsPublisher.swift
//  OwnGpt
//
//  Created by Bishalw on 7/25/24.
//

import Foundation
import Combine

protocol UserDefaultsPublisher {
    
}


class UserDefaultsPublisherImpl: ObservableObject {
    
    private let userDefaults: UserDefaults
    private let identifier: String?
    private var observers: [String: CurrentValueSubject<Any?, Error>] = [:]
    
    
    init?(identifier: String?) {
        guard let object = UserDefaults.init(suiteName: identifier) else { return nil}
        self.identifier = identifier
        self.userDefaults = object
    }

    func observer(forKey key: String) -> AnyPublisher<Any?, Error> {
        if let existingObserver = observers[key] {
            return existingObserver.eraseToAnyPublisher()
        }
        
        let subject = CurrentValueSubject<Any?, Error>(userDefaults.object(forKey: key))
        observers[key] = subject
        
    }
}

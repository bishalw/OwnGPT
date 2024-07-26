//
//  UserDefaultsPublisher.swift
//  OwnGpt
//
//  Created by Bishalw on 7/25/24.
//

import Foundation
import Combine

protocol PublishingUserDefaultsService{
    func observer(forKey key: String) -> AnyPublisher<Any?, Error>
    func set(value: Any?, forKey: String)
    func get(forKey: String) -> Any?
}


class PublishginUserDefaultsServiceImpl: ObservableObject {
    
    private let userDefaults: UserDefaults
    private var observers: [String: CurrentValueSubject<Any?, Error>] = [:]
    
    
    init?(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func observer(forKey key: String) -> AnyPublisher<Any?, Error> {
        // returns the publisher if it exists
        if let observerForKey = observers[key] {
            return observerForKey.eraseToAnyPublisher()
        }
        
        let subject = CurrentValueSubject<Any?, Error>(userDefaults.object(forKey: key))
        // [name: Obj]
        observers[key] = subject
        return subject.eraseToAnyPublisher()
        
    }
    
    func set(value: Any?, forKey: String) {
        self.userDefaults.set(value, forKey: forKey)
        observers[forKey]?.send(value)
    }
    
    func get(forKey: String) -> Any? {
        self.userDefaults.object(forKey: forKey)
    }
    
    func removeAllKeyvalue() {
        
    }
    
    
}

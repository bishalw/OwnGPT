//
//  UserDefaultsPublisher.swift
//  OwnGpt
//
//  Created by Bishalw on 7/25/24.
//

import Foundation
import Combine

protocol ObservableUserDefaultService{
    func observer<T>(forKey key: String) -> AnyPublisher<T?, Error>
    func set<T>(value: T, forKey: String)
    func get<T:Decodable>(forKey: String) -> T?
    func observer<T>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never>
}

class ObservableUserDefaultServiceImpl: ObservableUserDefaultService {
    
    private let userDefaults: UserDefaults
    private var observers: [String: CurrentValueSubject<Any?, Error>] = [:]
    private let queue = DispatchQueue(label: "com.OwnGPT.userDefaults\(UUID())", attributes: .concurrent)
    
    
    init(
        userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    func observer<T>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never> {
        queue.sync {
            // returns the publisher if it exists
            if let observerForKey = observers[key] {
                return observerForKey.eraseToAnyPublisher().map { item in
                    return item as? T ?? defaultValue
                }
                .replaceError(with: defaultValue)
                .eraseToAnyPublisher()
            }
            
            let subject = CurrentValueSubject<Any?, Error>(userDefaults.object(forKey: key))
            // [name: Obj]
            observers[key] = subject
            return subject.eraseToAnyPublisher().map { item in
                return item as? T ?? defaultValue
            }
            .replaceError(with: defaultValue)
            .eraseToAnyPublisher()
        }
    }
    func observer<T>(forKey key: String) -> AnyPublisher<T?, Error> {
        queue.sync {
            // returns the publisher if it exists
            if let observerForKey = observers[key] {
                return observerForKey.eraseToAnyPublisher().map { item in
                    return item as? T
                }.eraseToAnyPublisher()
            }
            
            let subject = CurrentValueSubject<Any?, Error>(userDefaults.object(forKey: key))
            // [name: Obj]
            observers[key] = subject
            return subject.eraseToAnyPublisher().map { item in
                return item as? T
            }.eraseToAnyPublisher()
        }
    }
    
    func set<T>(value: T, forKey key: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            // value for obj
            if let codableValue = value as? Codable {
                do {
                    let data = try JSONEncoder().encode(codableValue)
                    self.userDefaults.set(data, forKey: key)
                    observers[key]?.send(value)
                } catch {
                    Log.shared.logger.error("Error encoding value: \(error)")
                }
            } else {
                // default
                self.userDefaults.set(value, forKey: key)
                observers[key]?.send(value)
            }
        }
        
    }
    
    func get<T:Decodable>(forKey key : String) -> T? {
        queue.sync {
            if let value = self.userDefaults.object(forKey: key) as? T {
                return value
            } else if let data = self.userDefaults.data(forKey: key) {
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    Log.shared.logger.error("Error deocing value: \(error)")
                }
            }
            return nil
        }
    }
    
    func removeAllKeyvalue() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            for key in userDefaults.dictionaryRepresentation().keys {
                self.userDefaults.removeObject(forKey: key)
            }
            self.observers.removeAll()
        }
    }
}

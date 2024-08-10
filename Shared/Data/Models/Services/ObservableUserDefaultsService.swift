//
//  UserDefaultsPublisher.swift
//  OwnGpt
//
//  Created by Bishalw on 7/25/24.
//

import Foundation
import Combine

protocol ObservableUserDefaultService {
    func set<T>(value: T, forKey: String)
    func get<T:Decodable>(forKey: String) -> T?
    func userDefaultsPublisher<T:Decodable>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never>
}

class ObservableUserDefaultsServiceImpl: ObservableUserDefaultService {
    
    private let userDefaults: UserDefaults
    private var userDefaultsPublisherMap: [String: CurrentValueSubject<Any?, Error>] = [:]
    private let queue = DispatchQueue(label: "com.OwnGPT.userDefaults\(UUID())", attributes: .concurrent)
    
    
    init(
        userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
    func userDefaultsPublisher<T: Decodable>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never> {
        var publisher: AnyPublisher<T, Never>!
        
        queue.sync {
            // Get the current value first
            let currentValue: T = self.get(forKey: key) ?? defaultValue
            
            // If a publisher already exists, use it
            if let publisherForKey = userDefaultsPublisherMap[key] {
                publisher = publisherForKey.eraseToAnyPublisher()
                    .map { item -> T in
                        if let value = item as? T {
                            return value
                        } else {
                            return currentValue
                        }
                    }
                    .replaceError(with: currentValue)
                    .eraseToAnyPublisher()
            } else {
                // Create a new publisher with the current value
                let subject = CurrentValueSubject<Any?, Error>(currentValue)
                userDefaultsPublisherMap[key] = subject
                
                publisher = subject.eraseToAnyPublisher()
                    .map { item -> T in
                        if let value = item as? T {
                            return value
                        } else {
                            
                            return currentValue
                        }
                    }
                    .replaceError(with: currentValue)
                    .eraseToAnyPublisher()
            }
        }
        
        return publisher
    }

    
    func set<T>(value: T, forKey key: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            // value for obj
            if let codableValue = value as? Codable {
                do {
                    let data = try JSONEncoder().encode(codableValue)
                    self.userDefaults.set(data, forKey: key)
                    userDefaultsPublisherMap[key]?.send(value)
                } catch {
                    Log.shared.logger.error("Error encoding value: \(error)")
                }
            } else {
                // default
                self.userDefaults.set(value, forKey: key)
                userDefaultsPublisherMap[key]?.send(value)
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
}
    
//    func removeAllKeyvalue() {
//        queue.async(flags: .barrier) { [weak self] in
//            guard let self = self else { return }
//            for key in userDefaults.dictionaryRepresentation().keys {
//                self.userDefaults.removeObject(forKey: key)
//            }
//            self.userDefaultsPublisherMap.removeAll()
//        }
//    }


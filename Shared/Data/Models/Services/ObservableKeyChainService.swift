//
//  ObservableKeyChainService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/30/24.
//

import Combine
import Foundation

protocol ObservableKeyChainService {
    
    func keyChainPublisher<T: Codable>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never>
    func get<T: Codable>(forKey key: String) async -> T?
    func set<T: Codable>(_ value: T, forKey key: String) async
    func removeValue(forKey key: String) async
}

class ObservableKeyChainServiceImpl: ObservableKeyChainService {
    
    private let keychainService: KeyChainService
    private var keyChainPublishersMap: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.ObservableKeyChainService.\(UUID())", attributes: .concurrent)
    
    init(keychainService: KeyChainService) {
        self.keychainService = keychainService
    }
    
    func keyChainPublisher<T: Codable>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never> {
            queue.sync {
                Log.shared.logger.info("Accessing publisher for key: \(key)")
                if let publisher = keyChainPublishersMap[key] as? CurrentValueSubject<T, Never> {
                    Log.shared.logger.info("Returning existing publisher for key: \(key)")
                    return publisher.eraseToAnyPublisher()
                }

                print("Creating new publisher for key: \(key)")
                let subject = CurrentValueSubject<T, Never>(defaultValue)
                keyChainPublishersMap[key] = subject

                Task {
                    if let value: T = await get(forKey: key) {
                        Log.shared.logger.info("Fetched value for key \(key): \(value)")
                        await MainActor.run {
                            subject.send(value)
                        }
                    } else {
                        Log.shared.logger.info("No value found for key: \(key), using default: \(defaultValue)")
                        await MainActor.run {
                            subject.send(defaultValue)
                        }
                    }
                }

                return subject.eraseToAnyPublisher()
            }
        }
    
    func get<T: Codable>(forKey key: String) async -> T? {
        Log.shared.logger.info("Attempting to retrieve value for key \(key)")

        do {
            let value: T? = try await keychainService.retrieve(key)
            Log.shared.logger.info("Retrieved value for key \(key): \(String(describing: value))")
            return value
        } catch {
            Log.shared.logger.info("Error retrieving value from keychain for key \(key): \(error)")
            return nil
        }
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) async {
        do {
            try await keychainService.save(value, for: key)
            print("Saved value for key \(key): \(value)")
            queue.async {
                if let subject = self.keyChainPublishersMap[key] as? CurrentValueSubject<T, Never> {
                    subject.send(value)
                     Log.shared.logger.info("New value sent to publisher for key \(key)")
                }
            }
        } catch {
            Log.shared.logger.info("Error saving value to keychain for key \(key): \(error)")
        }
    }
    func removeValue(forKey key: String) async {
        do {
            try await keychainService.delete(for: key)
            queue.async {
                if let subject = self.keyChainPublishersMap[key] as? CurrentValueSubject<Any?, Never> {
                    subject.send(nil)
                }
            }
        } catch {
            Log.shared.logger.info("Error removing value from keychain: \(error)")
        }
    }
}

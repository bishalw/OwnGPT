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
    func fetchValueFromKeychain<T: Codable>(for key: String, ofType: T.Type, subject: CurrentValueSubject<Any?, Never>) async
    func setValue<T: Codable>(_ value: T, forKey key: String) async
    func removeValue(forKey key: String) async
}
class ObservableKeyChainServiceImpl: ObservableKeyChainService {
    
    private let keychainService: KeyChainService
    private var keyChainPublishersMap: [String: CurrentValueSubject<Any?, Never>] = [:]
    private let queue = DispatchQueue(label: "com.ObservableKeyChainService.\(UUID())", attributes: .concurrent)

    init(keychainService: KeyChainService = KeyChainServiceImpl()) {
        self.keychainService = keychainService
    }

    func keyChainPublisher<T: Codable>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never> {
        queue.sync {
            if let publisherForKey = keyChainPublishersMap[key] {
                return publisherForKey.compactMap { $0 as? T }
                    .replaceError(with: defaultValue)
                    .eraseToAnyPublisher()
            }

            let subject = CurrentValueSubject<Any?, Never>(nil)
            keyChainPublishersMap[key] = subject

            Task {
                await fetchValueFromKeychain(for: key, ofType: T.self, subject: subject)
            }

            return subject.compactMap { $0 as? T }
                .replaceError(with: defaultValue)
                .eraseToAnyPublisher()
        }
    }

     func fetchValueFromKeychain<T: Codable>(for key: String, ofType: T.Type, subject: CurrentValueSubject<Any?, Never>) async {
        do {
            let value: T? = try await keychainService.retrieve(key)
            await MainActor.run {
                subject.send(value)
            }
        } catch {
            print("Error retrieving value from keychain: \(error)")
            await MainActor.run {
                subject.send(nil)
            }
        }
    }

    func setValue<T: Codable>(_ value: T, forKey key: String) async {
        do {
            try await keychainService.save(value, for: key)
            await MainActor.run {
                keyChainPublishersMap[key]?.send(value)
            }
        } catch {
            print("Error saving value to keychain: \(error)")
        }
    }

    func removeValue(forKey key: String) async {
        do {
            try await keychainService.delete(for: key)
            await MainActor.run {
                keyChainPublishersMap[key]?.send(nil)
            }
        } catch {
            print("Error removing value from keychain: \(error)")
        }
    }
}

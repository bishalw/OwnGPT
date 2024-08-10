//
//  MockObservableUserDefaultsService.swift
//  OwnGpt
//
//  Created by Bishalw on 8/8/24.
//

import Foundation
import Combine
@testable import OwnGpt

class MockObservableUserDefaultsService: ObservableUserDefaultService {
    private var storage: [String: Any] = [:]
    private var subjects: [String: CurrentValueSubject<Any?, Error>] = [:]
    
    var observerCalls: [(key: String, type: Any.Type)] = []
    var setCalls: [(value: Any, key: String)] = []
    var getCalls: [(key: String, type: Any.Type)] = []
    var userDefaultsPublisherCalls: [(key: String, defaultValue: Any, type: Any.Type)] = []
    
    private var error: Error?

    func observer<T>(forKey key: String) -> AnyPublisher<T?, Error> {
        observerCalls.append((key: key, type: T.self))
        
        if let error = self.error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if subjects[key] == nil {
            subjects[key] = CurrentValueSubject<Any?, Error>(storage[key])
        }
        return subjects[key]!
            .compactMap { $0 as? T }
            .eraseToAnyPublisher()
    }
    
    func set<T>(value: T, forKey key: String) {
        setCalls.append((value: value, key: key))
        storage[key] = value
        subjects[key]?.send(value)
    }
    
    func get<T: Decodable>(forKey key: String) -> T? {
        getCalls.append((key: key, type: T.self))
        return storage[key] as? T
    }
    
    func userDefaultsPublisher<T: Decodable>(forKey key: String, defaultValue: T) -> AnyPublisher<T, Never> {
        userDefaultsPublisherCalls.append((key: key, defaultValue: defaultValue, type: T.self))
        
        if subjects[key] == nil {
            subjects[key] = CurrentValueSubject<Any?, Error>(storage[key] ?? defaultValue)
        }
        return subjects[key]!
            .compactMap { $0 as? T }
            .replaceError(with: defaultValue)
            .eraseToAnyPublisher()
    }
    
    func reset() {
        storage.removeAll()
        subjects.removeAll()
        observerCalls.removeAll()
        setCalls.removeAll()
        getCalls.removeAll()
        userDefaultsPublisherCalls.removeAll()
        error = nil
    }
    
    func simulateError(_ error: Error) {
        self.error = error
    }
}

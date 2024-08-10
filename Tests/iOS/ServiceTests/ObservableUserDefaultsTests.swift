//
//  ObservableUserDefaultsTests.swift
//  OwnGptTests
//
//  Created by Bishalw on 8/8/24.
//
import XCTest
import Combine
@testable import OwnGpt

class ObservableUserDefaultsServiceTests: XCTestCase {
    var userDefaultsService: ObservableUserDefaultsServiceImpl!
    var mockUserDefaults: UserDefaults!
    var cancellables: Set<AnyCancellable>!
    let suiteName = "com.test.userDefaults"

    override func setUp() {
        super.setUp()
        // Create a mock UserDefaults instance with a specific suite name
        mockUserDefaults = UserDefaults(suiteName: suiteName)
        mockUserDefaults.removePersistentDomain(forName: suiteName)
        
        userDefaultsService = ObservableUserDefaultsServiceImpl(userDefaults: mockUserDefaults)
        cancellables = []
    }

    override func tearDown() {
        // Clean up the mock UserDefaults
        mockUserDefaults.removePersistentDomain(forName: suiteName)
        mockUserDefaults = nil
        userDefaultsService = nil
        cancellables = nil
        super.tearDown()
    }

    // Your test cases go here

    func testSetAndGetStringValue() {
        let key = "testStringKey"
        let value = "TestString"

        userDefaultsService.set(value: value, forKey: key)
        let retrievedValue: String? = userDefaultsService.get(forKey: key)

        XCTAssertEqual(retrievedValue, value, "The retrieved value should match the set value.")
    }

    func testSetAndGetCodableValue() {
        struct TestCodable: Codable, Equatable {
            let id: Int
            let name: String
        }

        let key = "testCodableKey"
        let value = TestCodable(id: 1, name: "TestName")

        userDefaultsService.set(value: value, forKey: key)
        let retrievedValue: TestCodable? = userDefaultsService.get(forKey: key)

        XCTAssertEqual(retrievedValue, value, "The retrieved Codable value should match the set value.")
    }



    func testUserDefaultsPublisherWithDefaultValue() {
        let key = "testPublisherKey"
        let defaultValue = "DefaultValue"
        let updatedValue = "UpdatedValue"
        var receivedValues: [String] = []

        // Subscribe to the publisher
        let expectation = XCTestExpectation(description: "Publisher should emit the default value and then the updated value.")
        userDefaultsService.userDefaultsPublisher(forKey: key, defaultValue: defaultValue)
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Update the value
        userDefaultsService.set(value: updatedValue, forKey: key)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, [defaultValue, updatedValue], "Publisher should emit the default value and then the updated value.")
    }

    func testGetNonExistentKeyReturnsNil() {
        let key = "nonExistentKey"
        let retrievedValue: String? = userDefaultsService.get(forKey: key)

        XCTAssertNil(retrievedValue, "Retrieving a non-existent key should return nil.")
    }

    func testSetAndGetNonCodableValue() {
        let key = "testNonCodableKey"
        let value = 42

        userDefaultsService.set(value: value, forKey: key)
        let retrievedValue: Int? = userDefaultsService.get(forKey: key)

        XCTAssertEqual(retrievedValue, value, "The retrieved non-Codable value should match the set value.")
    }
}

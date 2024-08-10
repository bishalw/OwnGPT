//
//  UserDefaultsStoreTests.swift
//  OwnGptTests
//
//  Created by Bishalw on 8/8/24.
//

import XCTest

import XCTest
import Combine
@testable import OwnGpt

class UserDefaultsStoreTests: XCTestCase {
    var mockService: MockObservableUserDefaultsService!
    var userDefaultsStore: UserDefaultsStoreImpl!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockObservableUserDefaultsService()
        userDefaultsStore = UserDefaultsStoreImpl(observableUserDefaultService: mockService)
        cancellables = []
    }

    override func tearDown() {
        mockService.reset()
        cancellables = nil
        super.tearDown()
    }

    func testHasOnboarded() {
        // Test getting value
        _ = userDefaultsStore.hasOnboarded
        XCTAssertEqual(mockService.getCalls.count, 1)
        XCTAssertEqual(mockService.getCalls[0].key, "hasOnboarded")
        
        // Test setting value
        userDefaultsStore.hasOnboarded = true
        XCTAssertEqual(mockService.setCalls.count, 1)
        XCTAssertEqual(mockService.setCalls[0].key, "hasOnboarded")
        XCTAssertEqual(mockService.setCalls[0].value as? Bool, true)
    }

    func testHasUserOnboardedPublisher() {
        let expectation = self.expectation(description: "Publisher emits value")
        expectation.expectedFulfillmentCount = 2 // Expect two values: initial and after set
        var receivedValues: [Bool] = []

        userDefaultsStore.hasUserOnboardedPublisher
            .sink { value in
                receivedValues.append(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        XCTAssertEqual(mockService.userDefaultsPublisherCalls.count, 1)
        XCTAssertEqual(mockService.userDefaultsPublisherCalls[0].key, "hasOnboarded")
        XCTAssertEqual(mockService.userDefaultsPublisherCalls[0].defaultValue as? Bool, false)

        // Simulate a delay before setting the value
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mockService.set(value: true, forKey: "hasOnboarded")
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [false, true])
    }

    func testUserDefaultsPublisherNeverEmitsError() {
        let expectation = self.expectation(description: "Publisher emits value")
        
        // Simulate error
        let simulatedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockService.simulateError(simulatedError)

        mockService.userDefaultsPublisher(forKey: "hasOnboarded", defaultValue: false)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not receive an error")
                    }
                },
                receiveValue: { value in
                    XCTAssertFalse(value) // Should receive the default value
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
}
class ParentViewModel: ObservableObject {
    @Published var parentValue: Int = 0
    
    func updateFromChild(newValue: Int) {
        parentValue = newValue
    }
}

class ChildViewModel: ObservableObject {
    @Published var childValue: Int = 0
    var updateParent: ((Int) -> Void)?
    
    func incrementAndUpdate() {
        childValue += 1
        updateParent?(childValue)
    }
}

//
//  ObservableUserDefaultsTests.swift
//  OwnGptTests
//
//  Created by Bishalw on 8/8/24.
//

import XCTest

import XCTest
import Combine


class ObservableUserDefaultServiceTests: XCTestCase {
    
    var mockService: MockObservableUserDefaultsService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockObservableUserDefaultsService()
        cancellables = []
    }
    
    override func tearDown() {
        mockService.reset()
        cancellables = nil
        super.tearDown()
    }
    
    func testObserver() {
        var receivedValues: [String?] = []
        let expectation = self.expectation(description: "Received all expected values")
        
        let subscription = mockService.observer(forKey: "testKey")
            .sink(
                receiveCompletion: { completion in
                    print("Received completion: \(completion)")
                },
                receiveValue: { (value: String?) in
                    print("Received value: \(String(describing: value))")
                    receivedValues.append(value)
                    if receivedValues.count >= 3 {
                        expectation.fulfill()
                    }
                }
            )
        
        // Set initial value
        mockService.set(value: "testValue1", forKey: "testKey")
        
        // Set another value to trigger another emission
        mockService.set(value: "testValue2", forKey: "testKey")
        
        // Wait with a longer timeout
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Waitng for expectation failed: \(error)")
            }
        }
        
        subscription.cancel()  // Cancel the subscription after we're done

        print("Final received values: \(receivedValues)")
        
        XCTAssertEqual(receivedValues, [nil, "testValue1", "testValue2"])
        XCTAssertEqual(mockService.observerCalls.count, 1)
        XCTAssertEqual(mockService.observerCalls[0].key, "testKey")
        XCTAssertTrue(mockService.observerCalls[0].type == String.self)
    }
    
    func testSet() {
        mockService.set(value: 42, forKey: "intKey")
        XCTAssertEqual(mockService.setCalls.count, 1)
        XCTAssertEqual(mockService.setCalls[0].key, "intKey")
        XCTAssertEqual(mockService.setCalls[0].value as? Int, 42)
    }
    
    func testGet() {
        mockService.set(value: "testValue", forKey: "testKey")
        let value: String? = mockService.get(forKey: "testKey")
        XCTAssertEqual(value, "testValue")
        XCTAssertEqual(mockService.getCalls.count, 1)
        XCTAssertEqual(mockService.getCalls[0].key, "testKey")
        XCTAssertTrue(mockService.getCalls[0].type == String.self)
    }
}

//
//  DependencyCollectionTest.swift
//  ContextSDKTests
//
//  Created by Paul on 3.02.23.
//

import Combine
@testable import ContextSDK
import XCTest

class UOWStateCollectionContainerTests: XCTestCase {

    func testAddInitial() {
        var cancellables = Set<AnyCancellable>()
        var cnt1Count: Int = 0
        var cnt2Count: Int = 0
        let collection = UOWStateCollectionContainer<String>()
        collection.progressEventsPublisher
            .sink { value in
                switch value.subject {
                case "5":
                    cnt2Count -= 1
                    cnt1Count -= 1
                    XCTAssert(value.subordinatesInProgress == 0)
                case "4":
                    cnt2Count -= 1
                    cnt1Count -= 1
                    XCTAssert(value.subordinatesInProgress == 0)
                case "3":
                    cnt1Count -= 1
                    XCTAssert(value.subordinatesInProgress == 0)
                case "2":
                    cnt1Count -= 1
                    XCTAssert(value.subordinatesInProgress == 1)
                case "1":
                    print("? \(value.subordinatesInProgress)")
                    XCTAssert(value.subordinatesInProgress == 2)
                default: XCTAssert(false, "incorrect test")
                }
            }
            .store(in: &cancellables)

        collection.addAndNotify("1", parent: nil)
        collection.addAndNotify("2", parent: "1")
        collection.addAndNotify("3", parent: "1")
        collection.addAndNotify("4", parent: "2")
        collection.addAndNotify("5", parent: "2")

        collection.removeAndNotify("5")
        collection.removeAndNotify("4")
        collection.removeAndNotify("3")
        collection.removeAndNotify("2")
        collection.removeAndNotify("1")
    }

    func testAdd() {
        let collection = UOWStateCollectionContainer<String>()
        collection.addAndNotify("A", parent: nil)
        collection.addAndNotify("B", parent: "A")
        collection.addAndNotify("C", parent: "A")
        collection.addAndNotify("D", parent: "B")

        let result = collection.getCollection()

        XCTAssertEqual(result, ["A": ["A", "B", "C"], "B": ["B", "D"]])
    }
}

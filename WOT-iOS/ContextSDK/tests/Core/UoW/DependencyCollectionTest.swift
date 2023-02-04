//
//  DependencyCollectionTest.swift
//  ContextSDKTests
//
//  Created by Paul on 3.02.23.
//

import Combine
@testable import ContextSDK
import XCTest

class DependencyCollectionTest: XCTestCase {

    func testAddInitial() {
        var cancellables = Set<AnyCancellable>()
        var cnt1Count: Int = 0
        var cnt2Count: Int = 0
        let collection = DependencyCollection<String>()
        collection.deletionEventsPublisher
            .sink { value in
                switch value.subject {
                case "5": XCTAssert(value.completed == true)
                case "4": XCTAssert(value.completed == true)
                case "3": XCTAssert(value.completed == true)
                case "2":
                    cnt2Count += 1
                    let truth = cnt2Count == 2
                    XCTAssert(value.completed == truth)
                case "1":
                    cnt1Count += 1
                    let truth = cnt2Count == 2
                    XCTAssert(value.completed == truth)
                default: XCTAssert(false, "incorrect test")
                }
            }
            .store(in: &cancellables)

        collection.addAndNotify("1", parent: nil)
        collection.addAndNotify("2", parent: "1")
        collection.addAndNotify("3", parent: "1")
        collection.addAndNotify("4", parent: "2")
        collection.addAndNotify("5", parent: "2")

        collection.removeAndNotify("1")
        collection.removeAndNotify("3")
        collection.removeAndNotify("2")
        collection.removeAndNotify("5")
        collection.removeAndNotify("4")
    }

    func testAdd() {
        let collection = DependencyCollection<String>()
        collection.addAndNotify("A", parent: nil)
        collection.addAndNotify("B", parent: "A")
        collection.addAndNotify("C", parent: "A")
        collection.addAndNotify("D", parent: "B")

        let result = collection.getCollection()

        XCTAssertEqual(result, ["A": ["A", "B", "C"], "B": ["B", "D"]])
    }
}

//
//  WOTNodeTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOT

class WOTNodeTest: XCTestCase {

    var asyncExpectation: XCTestExpectation?

    func testName() {

        let node = WOTNodeSwift(name: "test")
        XCTAssert(node.isVisible == true)
        XCTAssert(node.name.compare("test") == .orderedSame)
        XCTAssert(node.fullName.compare("test") == .orderedSame)
    }

    func testFullName() {
        let parent = WOTNodeSwift(name: "testParent")
        let node = WOTNodeSwift(name: "test")
        parent.addChild(node)
        XCTAssert(node.fullName.compare("testParent.test") == .orderedSame)
    }

    func testHash() {
        let node = WOTNodeSwift(name: "test")
        XCTAssert(node.hashValue == 1800117029, "expected hashvalue:\(node.hashValue)")
        XCTAssert(node.hashValue == node.hash)
        XCTAssert(node.hashString.compare("1800117029") == .orderedSame)
    }

    func testAddChildArray() {
        let node = WOTNodeSwift(name: "parent")
        let children = [WOTNodeSwift(name: "child1"), WOTNodeSwift(name: "child2"), WOTNodeSwift(name: "child5")]
        node.addChildArray(children)
        XCTAssert(node.children.count == 3)
        XCTAssert(node.children[2].name.compare("child5") == .orderedSame)
    }

    func testRemoveChildren() {

        let testRemoveChildrenExpectation = expectation(description: "testRemoveChildren expectation")

        let node = WOTNodeSwift(name: "parent")
        let childToRemove = WOTNodeSwift(name: "child1")
        let children = [childToRemove, WOTNodeSwift(name: "child2"), WOTNodeSwift(name: "child5")]
        node.addChildArray(children)
        node.removeChildren { (_) in
            testRemoveChildrenExpectation.fulfill()
        }

        waitForExpectations(timeout: 12) { (err) in
            if let error = err {
                XCTFail("wait for expectation error:\(String(describing: error))")
            }

            XCTAssert(node.children.count == 0)
        }
    }

    func testRemoveChild() {

        let aExpectation = expectation(description: "testRemoveChild expectation")

        let node = WOTNodeSwift(name: "parent")
        let childToRemove = WOTNodeSwift(name: "child1")
        let child5 = WOTNodeSwift(name: "child5")
        let children = [childToRemove, WOTNodeSwift(name: "child2"), child5]
        node.addChildArray(children)
        node.removeChild(childToRemove, completion: { _ in

            aExpectation.fulfill()

        })

        waitForExpectations(timeout: 12) { (err) in
            if let error = err {
                XCTFail("wait for expectation error:\(String(describing: error))")
            }

            XCTAssert(node.children.count == 2)
            let compareNameResult = WOTNodeSwift.WOTNodeNameComparator(child5, node.children[1], -1)
            XCTAssert(compareNameResult == .orderedSame)
        }
    }

    func testComparators() {
        let child1 = WOTNodeSwift(name: "child1")
        let child2 = WOTNodeSwift(name: "child2")

        let emptyComparatorResult = WOTNodeSwift.WOTNodeEmptyComparator(child1, child2, -1)
        XCTAssert(emptyComparatorResult == .orderedSame)

        let compareNameResult = WOTNodeSwift.WOTNodeNameComparator(child1, child2, -1)
        XCTAssert(compareNameResult == .orderedAscending)

    }

    func testCopy() {
        let node = WOTNodeSwift(name: "parent")
        node.isVisible = false
        guard let copy = node.copy(with: nil) as? WOTNodeSwift else {
            XCTAssert(false, "invalid copy")
            return
        }
        XCTAssert(copy.isVisible == false)
        XCTAssert(copy.name.compare("parent") == .orderedSame)

    }
}

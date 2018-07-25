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

        let node = WOTNode(name: "test")
        XCTAssert(node.isVisible == true)
        XCTAssert(node.name.compare("test") == .orderedSame)
        XCTAssert(node.fullName.compare("test") == .orderedSame)
    }

    func testFullName() {
        let parent = WOTNode(name: "testParent")
        let node = WOTNode(name: "test")
        parent.addChild(node)
        XCTAssert(node.fullName.compare("testParent.test") == .orderedSame)
    }

    func testHash() {
        let node = WOTNode(name: "test")
        XCTAssert(node.hashValue == 4799450093349215013, "expected hashvalue:\(node.hashValue)")
        XCTAssert(node.hashValue == node.hash)
//        XCTAssert(node.hashString.compare("4799450093349215013") == .orderedSame)
    }

    func testAddChildArray() {
        let node = WOTNode(name: "parent")
        let children = [WOTNode(name: "child1"), WOTNode(name: "child2"), WOTNode(name: "child5")]
        node.addChildArray(children)
        XCTAssert(node.children.count == 3)
        XCTAssert(node.children[2].name.compare("child5") == .orderedSame)
    }

    func testRemoveChildren() {

        let testRemoveChildrenExpectation = expectation(description: "testRemoveChildren expectation")

        let node = WOTNode(name: "parent")
        let childToRemove = WOTNode(name: "child1")
        let children = [childToRemove, WOTNode(name: "child2"), WOTNode(name: "child5")]
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

        let node = WOTNode(name: "parent")
        let childToRemove = WOTNode(name: "child1")
        let child5 = WOTNode(name: "child5")
        let children = [childToRemove, WOTNode(name: "child2"), child5]
        node.addChildArray(children)
        node.removeChild(childToRemove, completion: { _ in

            aExpectation.fulfill()

        })

        waitForExpectations(timeout: 12) { (err) in
            if let error = err {
                XCTFail("wait for expectation error:\(String(describing: error))")
            }

            XCTAssert(node.children.count == 2)
            let compareNameResult = WOTNode.WOTNodeNameComparator(child5, node.children[1], -1)
            XCTAssert(compareNameResult == .orderedSame)
        }
    }

    func testComparators() {
        let child1 = WOTNode(name: "child1")
        let child2 = WOTNode(name: "child2")

        let emptyComparatorResult = WOTNode.WOTNodeEmptyComparator(child1, child2, -1)
        XCTAssert(emptyComparatorResult == .orderedSame)

        let compareNameResult = WOTNode.WOTNodeNameComparator(child1, child2, -1)
        XCTAssert(compareNameResult == .orderedAscending)

    }

    func testCopy() {
        let node = WOTNode(name: "parent")
        node.isVisible = false
        guard let copy = node.copy(with: nil) as? WOTNode else {
            XCTAssert(false, "invalid copy")
            return
        }
        XCTAssert(copy.isVisible == false)
        XCTAssert(copy.name.compare("parent") == .orderedSame)

    }
}

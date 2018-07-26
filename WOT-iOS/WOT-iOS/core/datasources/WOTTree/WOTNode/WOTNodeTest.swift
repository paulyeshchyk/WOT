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
        //        XCTAssert(node.hashValue == 4799450093349215013, "expected hashvalue:\(node.hashValue)")
        XCTAssert(node.hashValue == node.hash)
    }

    func testParentProperty() {
        let node = WOTNode(name: "parent")
        let child = WOTNode(name: "child")
        node.addChild(child)
        XCTAssert(child.parent === node)
        XCTAssert(child.fullName.compare("parent.child") == .orderedSame)

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

    func testRemoveParent() {
        let parent = WOTNode(name: "parent")
        let child = WOTNode(name: "child")
        parent.addChild(child)
        child.removeParent()
        XCTAssert(child.parent == nil)
        XCTAssert(parent.children.count == 0)
    }

    func testDeleteChild() {
        let parent = WOTNode(name: "parent")
        let child = WOTNode(name: "child2")
        parent.children.append(WOTNode(name: "child1"))
        parent.children.append(child)
        parent.children.append(WOTNode(name: "child3"))
        XCTAssert(parent.children.count == 3)
        parent.removeChild(child) { (_) in

        }
        XCTAssert(parent.children.count == 2)
    }

    func testDeleteUnlinkedChild() {
        let parent = WOTNode(name: "parent")
        parent.children.append(WOTNode(name: "child1"))
        XCTAssert(parent.children.count == 1)
        let unlinkedChild = WOTNode(name: "unlinkedChild")
        parent.removeChild(unlinkedChild) { (_) in

        }
        XCTAssert(parent.children.count == 1)
    }

    func testUnlinkChild() {
        let child1 = WOTNode(name: "child1")
        let child2 = WOTNode(name: "child2")
        let node = WOTNode(name: "parent")
        node.addChildArray([child1, child2])
        XCTAssert(node.children.count == 2)
        XCTAssert(child1.parent === node)
        child1.unlinkFromParent()
        XCTAssert(node.children.count == 1)
        XCTAssert(child1.parent == nil)
    }

    func testUnlinkGranyChild() {
        let child1 = WOTNode(name: "child1")
        let child2 = WOTNode(name: "child2")
        let node = WOTNode(name: "parent")
        node.addChildArray([child1, child2])
        let granny = WOTNode(name: "granny")
        granny.addChild(node)
        child1.unlinkFromParent()
        XCTAssert(node.children.count == 1)

        node.unlinkChild(child1)
        XCTAssert(node.children.count == 1)

        child1.unlinkFromParent()
        XCTAssert(child1.parent == nil)
    }

    func testMigrateChildren() {
        let granChild = WOTNode(name: "granChild")
        let child1 = WOTNode(name: "child1")
        child1.addChild(granChild)
        let child2 = WOTNode(name: "child2")
        let node = WOTNode(name: "parent")
        node.addChildArray([child1, child2])

        let node2 = WOTNode(name: "neighbour")
        node2.addChild(child1)
        XCTAssert(granChild.parent === child1)
        XCTAssert(child1.parent === node2)
        XCTAssert(node.children.count == 1)

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

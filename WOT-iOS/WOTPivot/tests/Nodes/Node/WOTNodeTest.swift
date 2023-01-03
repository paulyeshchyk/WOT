//
//  WOTNodeTest.swift
//  WOT-iOSTests
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

@testable import WOTPivot
import XCTest

class WOTNodeTest: XCTestCase {
    static let WOTNodeEmptyComparator: NodeComparatorType = { (_, _, _) in
        return .orderedSame
    }

    static let WOTNodeNameComparator: NodeComparatorType = { (node1, node2, _) in
        return node1.name.compare(node2.name)
    }

    var asyncExpectation: XCTestExpectation?

    func testName() {
        let node = Node(name: "test")
        XCTAssert(node.isVisible == true)
        XCTAssert(node.name.compare("test") == .orderedSame)
        XCTAssert(node.fullName.compare("test") == .orderedSame)
    }

    func testFullName() {
        let parent = Node(name: "testParent")
        let node = Node(name: "test")
        parent.addChild(node)
        XCTAssert(node.fullName.compare("testParent.test") == .orderedSame)
    }

    func testHash() {
        let node = Node(name: "test")
        //        XCTAssert(node.hashValue == 4799450093349215013, "expected hashvalue:\(node.hashValue)")
        XCTAssert(node.hashValue == node.hash)
    }

    func testValueForKey() {
        let node = Node(name: "test")
        XCTAssert(node.value(key: "test") == nil)
    }

    func testParentProperty() {
        let node = Node(name: "parent")
        let child = Node(name: "child")
        node.addChild(child)
        XCTAssert(child.parent === node)
        XCTAssert(child.fullName.compare("parent.child") == .orderedSame)
    }

    func testAddChildArray() {
        let node = Node(name: "parent")
        let children = [Node(name: "child1"), Node(name: "child2"), Node(name: "child5")]
        node.addChildArray(children)
        XCTAssert(node.children.count == 3)
        XCTAssert(node.children[2].name.compare("child5") == .orderedSame)
    }

    func testRemoveChildren() {
        let testRemoveChildrenExpectation = expectation(description: "testRemoveChildren expectation")
        let node = Node(name: "parent")
        let childToRemove = Node(name: "child1")
        let children = [childToRemove, Node(name: "child2"), Node(name: "child5")]
        node.addChildArray(children)
        node.removeChildren { (_) in
            testRemoveChildrenExpectation.fulfill()
        }
        waitForExpectations(timeout: 12) { (err) in
            if let error = err {
                XCTFail("wait for expectation error:\(String(describing: error))")
            }

            XCTAssert(node.children.isEmpty)
        }
    }

    func testRemoveParent() {
        let parent = Node(name: "parent")
        let child = Node(name: "child")
        parent.addChild(child)
        child.removeParent()
        XCTAssert(child.parent == nil)
        XCTAssert(parent.children.isEmpty)
    }

    func testDeleteChild() {
        let parent = Node(name: "parent")
        let child = Node(name: "child2")
        parent.children.append(Node(name: "child1"))
        parent.children.append(child)
        parent.children.append(Node(name: "child3"))
        XCTAssert(parent.children.count == 3)
        parent.removeChild(child) { (_) in
        }
        XCTAssert(parent.children.count == 2)
    }

    func testDeleteUnlinkedChild() {
        let parent = Node(name: "parent")
        parent.children.append(Node(name: "child1"))
        XCTAssert(parent.children.count == 1)
        let unlinkedChild = Node(name: "unlinkedChild")
        parent.removeChild(unlinkedChild) { (_) in
        }
        XCTAssert(parent.children.count == 1)
    }

    func testUnlinkChild() {
        let child1 = Node(name: "child1")
        let child2 = Node(name: "child2")
        let node = Node(name: "parent")
        node.addChildArray([child1, child2])
        XCTAssert(node.children.count == 2)
        XCTAssert(child1.parent === node)
        child1.unlinkFromParent()
        XCTAssert(node.children.count == 1)
        XCTAssert(child1.parent == nil)
    }

    func testUnlinkGranyChild() {
        let child1 = Node(name: "child1")
        let child2 = Node(name: "child2")
        let node = Node(name: "parent")
        node.addChildArray([child1, child2])
        let granny = Node(name: "granny")
        granny.addChild(node)
        child1.unlinkFromParent()
        XCTAssert(node.children.count == 1)

        node.unlinkChild(child1)
        XCTAssert(node.children.count == 1)

        child1.unlinkFromParent()
        XCTAssert(child1.parent == nil)
    }

    func testMigrateChildren() {
        let granChild = Node(name: "granChild")
        let child1 = Node(name: "child1")
        child1.addChild(granChild)
        let child2 = Node(name: "child2")
        let node = Node(name: "parent")
        node.addChildArray([child1, child2])

        let node2 = Node(name: "neighbour")
        node2.addChild(child1)
        XCTAssert(granChild.parent === child1)
        XCTAssert(child1.parent === node2)
        XCTAssert(node.children.count == 1)
    }

    func testSubscript() {
        let node = Node(name: "node")
        let child2 = Node(name: "child2")
        let child = Node(name: "child")
        node.addChild(child)
        XCTAssert(node[0] === child)
        node[0] = child2
        XCTAssert(node[0].name.compare("child2") == .orderedSame)
        XCTAssert(node[0].parent === node)
    }

    func testComparators() {
        let child1 = Node(name: "child1")
        let child2 = Node(name: "child2")

        let emptyComparatorResult = WOTNodeTest.WOTNodeEmptyComparator(child1, child2, -1)
        XCTAssert(emptyComparatorResult == .orderedSame)

        let compareNameResult = WOTNodeTest.WOTNodeNameComparator(child1, child2, -1)
        XCTAssert(compareNameResult == .orderedAscending)
    }

    func testCopy() {
        let node = Node(name: "parent")
        node.isVisible = false
        guard let copy = node.copy(with: nil) as? Node else {
            XCTAssert(false, "invalid copy")
            return
        }
        XCTAssert(copy.isVisible == false)
        XCTAssert(copy.name.compare("parent") == .orderedSame)
    }
}

//
//  WOTPivotNodeTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 7/25/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOT

class WOTPivotNodeTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCopy() {
        let node = WOTPivotNode(name: "node")
        node.predicate = NSPredicate(format: "data1 == %d", 1)
        node.dataColor = UIColor.white

        guard let copy = node.copy(with: nil) as? WOTPivotNodeProtocol else {
            XCTAssert(false, "wrong copy")
            return
        }
        XCTAssert(copy.name.compare("node") == .orderedSame)
        XCTAssert(copy.predicate?.predicateFormat.compare("data1 == 1") == .orderedSame)
        XCTAssert(copy.dataColor == UIColor.white)
        XCTAssert(copy.stickyType == .float)
        XCTAssert(copy.relativeRect == nil)
        XCTAssert(copy.indexInsideStepParentColumn == 0)
        XCTAssert(copy.stepParentColumn == nil)
        XCTAssert(copy.stepParentRow == nil)
    }

    func testFullPredicate() {
        let node = WOTPivotNode(name: "node")
        XCTAssert(node.predicate == nil)
        XCTAssert(node.cellType == .data)

        let nodePredicate = NSPredicate(format: "data1 == %d", 1)
        node.predicate = nodePredicate

        let childPredicate = NSPredicate(format: "data1 == %d", 2)
        let child = WOTPivotNode(name: "child")
        child.predicate = childPredicate
        node.addChild(child)

        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [childPredicate, nodePredicate])
        guard let fullPredicate = child.fullPredicate else {
            XCTAssert(false)
            return
        }
        XCTAssert(fullPredicate.predicateFormat.compare(compound.predicateFormat) == .orderedSame)
    }

    func testInitNamePredicate() {
        let nodePredicate = NSPredicate(format: "data1 == %d", 1)
        let node = WOTPivotNode(name: "node", predicate: nodePredicate)
        XCTAssert(node.predicate?.predicateFormat.compare(nodePredicate.predicateFormat) == .orderedSame)

    }
}

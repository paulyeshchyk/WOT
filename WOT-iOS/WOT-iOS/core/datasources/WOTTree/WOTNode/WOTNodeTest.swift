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

    func testName() {

        let node = WOTNodeSwift(name: "test")
        XCTAssert(node.name.compare("test") == .orderedSame)
        XCTAssert(node.fullName.compare("test") == .orderedSame)
    }

    func testFullName() {
        let parent = WOTNodeSwift(name: "testParent")
        let node = WOTNodeSwift(name: "test")
        parent.addChild(node)
        XCTAssert(node.fullName.compare("testParent.test") == .orderedSame)
    }

}

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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

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

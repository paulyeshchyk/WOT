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

        let copy = node.copy(with: nil)
    }

}

//
//  WOTNodePivotFactoryTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 7/12/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOT

class WOTNodePivotFactoryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNation() {
        guard let node = WOTNode.pivotNationMetadataItem(as: PivotMetadataType.column) else {
            XCTAssert(false, "nation not found")
            return
        }
        let depth = WOTNodeEnumerator.sharedInstance.depth(forChildren: node.children, initialLevel: 0)
        XCTAssert(depth == 1)
    }

    func testTier() {
        guard let node = WOTNode.pivotTierMetadataItem(as: PivotMetadataType.column) else {
            XCTAssert(false, "nation not found")
            return
        }
        let depth = WOTNodeEnumerator.sharedInstance.depth(forChildren: node.children, initialLevel: 0)
        XCTAssert(depth == 1)
    }

    func testType() {
        guard let node = WOTNode.pivotTypeMetadataItem(as: PivotMetadataType.column) else {
            XCTAssert(false, "nation not found")
            return
        }
        let depth = WOTNodeEnumerator.sharedInstance.depth(forChildren: node.children, initialLevel: 0)
        XCTAssert(depth == 1)
    }

}

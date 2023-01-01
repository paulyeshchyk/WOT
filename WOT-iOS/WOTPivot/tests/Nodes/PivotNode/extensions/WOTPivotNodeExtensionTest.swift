//
//  WOTPivotNodeExtensionTest.swift
//  WOTPivotTests
//
//  Created on 8/15/18.
//  Copyright © 2018. All rights reserved.
//

@testable import WOTPivot
import XCTest

class WOTPivotFilterNodeTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFilter() {
        let node = FilterPivotNode(name: "node")
        XCTAssert(node.cellType == PivotCellType.filter)

        let horizontal = UInt8(PivotStickyType.horizontal.rawValue)
        let vertical = UInt8(PivotStickyType.vertical.rawValue)
        let raw = PivotStickyType.RawValue(horizontal | vertical)

        XCTAssert(node.stickyType == PivotStickyType(rawValue: raw))
    }

    func testRow() {
        let node = RowPivotNode(name: "node")
        XCTAssert(node.cellType == PivotCellType.row)
        XCTAssert(node.stickyType == PivotStickyType.horizontal)
    }

    func testCol() {
        let node = ColPivotNode(name: "node")
        XCTAssert(node.cellType == PivotCellType.column)
        XCTAssert(node.stickyType == PivotStickyType.vertical)
    }

    func testDataGroupNode() {
        let node = DataGroupPivotNode(name: "node")
        XCTAssert(node.cellType == .dataGroup)
    }

    func testDataNode() {
        let node = DataPivotNode(name: "node")
        XCTAssert(node.cellType == .data)
    }
}

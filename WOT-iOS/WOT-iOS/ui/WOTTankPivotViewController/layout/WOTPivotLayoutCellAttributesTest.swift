//
//  WOTPivotLayoutCellAttributesTest.swift
//  WOT-iOSTests
//
//  Created on 7/26/18.
//  Copyright © 2018. All rights reserved.
//

import XCTest
@testable import WOT

class WOTPivotLayoutCellAttributesTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        let rect = CGRect(x: 12, y: 13, width: 14, height: 15)
        let indexPath = IndexPath(row: 3, section: 4)
        let attrs = WOTPivotLayoutCellAttributes(cellRect: rect, cellZIndex: 1, cellIndexPath: indexPath)
        XCTAssert(attrs.indexPath.row == 3)
        XCTAssert(attrs.indexPath.section == 4)
        XCTAssert(attrs.zIndex == 1)
        XCTAssert(attrs.rect.origin.x == 12)
        XCTAssert(attrs.rect.origin.y == 13)
        XCTAssert(attrs.rect.width == 14)
        XCTAssert(attrs.rect.height == 15)
    }

    func testForNilIntersect() {
        let rect = CGRect(x: 12, y: 13, width: 14, height: 15)
        let indexPath = IndexPath(row: 3, section: 4)
        let attrs = WOTPivotLayoutCellAttributes(cellRect: rect, cellZIndex: 1, cellIndexPath: indexPath)
        let result = attrs.collectionViewLayoutAttributes(forRect: CGRect(x: 100, y: 200, width: 3, height: 2))
        XCTAssert(result == nil)
    }

    func testForIntersect() {
        let rect = CGRect(x: 12, y: 13, width: 14, height: 15)
        let indexPath = IndexPath(row: 3, section: 4)
        let attrs = WOTPivotLayoutCellAttributes(cellRect: rect, cellZIndex: 1, cellIndexPath: indexPath)
        let result = attrs.collectionViewLayoutAttributes(forRect: CGRect(x: 12, y: 13, width: 3, height: 2))
        XCTAssert(result != nil)
    }

}

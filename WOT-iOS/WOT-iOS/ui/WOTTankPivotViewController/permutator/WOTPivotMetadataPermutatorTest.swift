//
//  WOTPivotMetadataPermutatorTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 8/13/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOT

class WOTPivotMetadataPermutatorTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test2LevelColumns() {
        let templates = WOTPivotTemplates()
        let levelPrem = templates.vehiclePremium.asType(.column)
        let levelNation = templates.vehicleNation.asType(.column)

        let permutator = WOTPivotMetadataPermutator()

        let cols = permutator.permutate(pivotNodes: [levelPrem, levelNation])
        XCTAssert(cols.count == 11)
        let column = cols[0]
        XCTAssert(column.children.count == 2)
    }

    func test3LevelColumns() {

        let templates = WOTPivotTemplates()
        let levelPrem = templates.vehiclePremium.asType(.column)
        let levelNation = templates.vehicleNation.asType(.column)
        let levelTier = templates.vehicleTier.asType(.column)

        let permutator = WOTPivotMetadataPermutator()

        let cols = permutator.permutate(pivotNodes: [levelTier, levelPrem, levelNation])
        XCTAssert(cols.count == 11)
        let columnPrem = cols[0]
        XCTAssert(columnPrem.children.count == 2)
        let columnTier = columnPrem.children[0]
        XCTAssert(columnTier.children.count == 10)
    }

}

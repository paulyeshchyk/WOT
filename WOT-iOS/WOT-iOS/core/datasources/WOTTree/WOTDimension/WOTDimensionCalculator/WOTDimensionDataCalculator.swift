//
//  WOTDimensionDataCalculator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/16/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTDimensionDataCalculator: WOTDimensionCalculator {

    override class func x(forNode: WOTNodeProtocol, dimension: WOTDimensionProtocol) -> Int {

        guard let stepParentColumn = forNode.stepParentColumn else {
            return 0
        }
        guard let calculator = dimension.calculatorClass(forNodeClass: type(of: stepParentColumn)) else {
            return 0
        }

        let relativeRect = calculator.rectangle(forNode: stepParentColumn, dimension: dimension)

        var result: Int = Int(relativeRect.origin.x)
        result += forNode.indexInsideStepParentColumn
        return result
    }

    override class func y(forNode: WOTNodeProtocol, dimension: WOTDimensionProtocol) -> Int {

        guard let stepParentRow = forNode.stepParentRow else {
            return 0
        }
        guard let calculator = dimension.calculatorClass(forNodeClass: type(of: stepParentRow)) else {
            return 0
        }

        let relativeRect = calculator.rectangle(forNode: stepParentRow, dimension: dimension)

        return Int(relativeRect.origin.y)
    }

    override class func width(forNode: WOTNodeProtocol, dimension: WOTDimensionProtocol) -> Int {
        return 1
    }

    override class func height(forNode: WOTNodeProtocol, dimension: WOTDimensionProtocol) -> Int {
        return 1
    }
}

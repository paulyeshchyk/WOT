//
//  WOTDimensionDataCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTDimensionDataCalculator: WOTDimensionCalculator {

    override class func x(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        guard let node = forNode as? WOTPivotNodeProtocol else {
            return 0
        }
        guard let stepParentColumn = node.stepParentColumn else {
            return 0
        }
        guard let pivotDimension = dimension as? WOTPivotDimension else {
            return 0
        }
        guard let calculator = pivotDimension.calculatorClass(forNodeClass: type(of: stepParentColumn)) else {
            return 0
        }

        let relativeRect = calculator.rectangle(forNode: stepParentColumn, dimension: dimension)

        var result: Int = Int(relativeRect.origin.x)
        result += node.indexInsideStepParentColumn
        return result
    }

    override class func y(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        guard let node = forNode as? WOTPivotNodeProtocol else {
            return 0
        }
        guard let stepParentRow = node.stepParentRow else {
            return 0
        }
        guard let pivotDimension = dimension as? WOTPivotDimension else {
            return 0
        }
        guard let calculator = pivotDimension.calculatorClass(forNodeClass: type(of: stepParentRow)) else {
            return 0
        }

        let relativeRect = calculator.rectangle(forNode: stepParentRow, dimension: dimension)

        return Int(relativeRect.origin.y)
    }

    override class func width(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return 1
    }

    override class func height(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return 1
    }
}

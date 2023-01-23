//
//  WOTDimensionDataCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

public class DataPivotDimensionCalculator: PivotDimensionCalculator {
    override class func x(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        guard let node = forNode as? PivotNodeProtocol else {
            return 0
        }
        guard let stepParentColumn = node.stepParentColumn else {
            return 0
        }
        guard let pivotDimension = dimension as? PivotNodeDimension else {
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

    override class func y(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        guard let node = forNode as? PivotNodeProtocol else {
            return 0
        }
        guard let stepParentRow = node.stepParentRow else {
            return 0
        }
        guard let pivotDimension = dimension as? PivotNodeDimension else {
            return 0
        }
        guard let calculator = pivotDimension.calculatorClass(forNodeClass: type(of: stepParentRow)) else {
            return 0
        }

        let relativeRect = calculator.rectangle(forNode: stepParentRow, dimension: dimension)
        let result: Int = Int(relativeRect.origin.y)
        return result
    }

    override class func width(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 1
    }

    override class func height(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 1
    }
}

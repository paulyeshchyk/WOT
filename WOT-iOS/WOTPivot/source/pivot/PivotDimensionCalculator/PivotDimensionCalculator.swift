//
//  WOTDimensionCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - PivotDimensionCalculatorProtocol

public protocol PivotDimensionCalculatorProtocol {
    static func rectangle(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> CGRect
}

// MARK: - PivotDimensionCalculator

public class PivotDimensionCalculator: PivotDimensionCalculatorProtocol {

    public static func rectangle(forNode node: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> CGRect {
        return CGRect(x: x(forNode: node, dimension: dimension),
                      y: y(forNode: node, dimension: dimension),
                      width: width(forNode: node, dimension: dimension),
                      height: height(forNode: node, dimension: dimension))
    }

    class func x(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int { return 0 }
    class func y(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int { return 0 }
    class func width(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int { return 0 }
    class func height(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int { return 0 }
}

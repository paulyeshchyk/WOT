//
//  WOTDimensionCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public protocol WOTDimensionCalculatorProtocol {
    static func rectangle(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> CGRect
}

public class WOTDimensionCalculator: WOTDimensionCalculatorProtocol {
    public static func rectangle(forNode node: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> CGRect {
        return CGRect(x: x(forNode: node, dimension: dimension),
                      y: y(forNode: node, dimension: dimension),
                      width: width(forNode: node, dimension: dimension),
                      height: height(forNode: node, dimension: dimension))
    }

    class func x(forNode _: WOTNodeProtocol, dimension _: WOTPivotDimensionProtocol) -> Int { return 0 }
    class func y(forNode _: WOTNodeProtocol, dimension _: WOTPivotDimensionProtocol) -> Int { return 0 }
    class func width(forNode _: WOTNodeProtocol, dimension _: WOTPivotDimensionProtocol) -> Int { return 0 }
    class func height(forNode _: WOTNodeProtocol, dimension _: WOTPivotDimensionProtocol) -> Int { return 0 }
}

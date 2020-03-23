//
//  WOTDimensionCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol WOTDimensionCalculatorProtocol {
    static func rectangle(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> CGRect
}

public class WOTDimensionCalculator: WOTDimensionCalculatorProtocol {
    public static func rectangle(forNode node: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> CGRect {
        return CGRect(x: self.x(forNode: node, dimension: dimension),
                      y: self.y(forNode: node, dimension: dimension),
                      width: self.width(forNode: node, dimension: dimension),
                      height: self.height(forNode: node, dimension: dimension))
    }

    class func x(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int { return 0 }
    class func y(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int { return 0 }
    class func width(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int { return 0 }
    class func height(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int { return 0 }
}

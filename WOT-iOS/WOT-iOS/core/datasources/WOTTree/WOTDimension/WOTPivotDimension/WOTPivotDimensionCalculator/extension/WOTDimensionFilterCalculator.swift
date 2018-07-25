//
//  WOTDimensionFilterCalculator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/16/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTDimensionFilterCalculator: WOTDimensionCalculator {

    override class func x(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return 0
    }

    override class func y(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return 0
    }

    override class func width(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return dimension.rootNodeWidth
    }

    override class func height(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return dimension.rootNodeHeight
    }
}

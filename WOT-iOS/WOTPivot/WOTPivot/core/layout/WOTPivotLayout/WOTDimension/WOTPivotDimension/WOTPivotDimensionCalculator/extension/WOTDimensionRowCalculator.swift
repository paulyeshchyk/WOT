//
//  WOTDimensionRowCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTDimensionRowCalculator: WOTDimensionCalculator {

    override class func x(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return WOTNodeEnumerator.sharedInstance.visibleParentsCount(node: forNode)
    }

    override class func y(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        var result: Int = WOTNodeEnumerator.sharedInstance.childrenWidth(siblingNode: forNode, orValue: 1)
        result += dimension.rootNodeHeight
        return result
    }

    override class func width(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return 1
    }

    override class func height(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return WOTNodeEnumerator.sharedInstance.endpoints(node: forNode).count
    }
}

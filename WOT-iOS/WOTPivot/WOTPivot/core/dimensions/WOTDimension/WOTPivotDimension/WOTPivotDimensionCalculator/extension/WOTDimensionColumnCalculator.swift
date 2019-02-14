//
//  WOTDimensionColumnCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTDimensionColumnCalculator: WOTDimensionCalculator {

    override class func x(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        var result: Int = dimension.childrenMaxWidth(forNode, orValue: 0)
        result += dimension.rootNodeWidth
        return result
    }

    override class func y(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return WOTNodeEnumerator.sharedInstance.visibleParentsCount(node: forNode)
    }

    override class func width(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: forNode)
        guard endpoints.count > 0 else {
            return 1
        }

        var result: Int = 0
        endpoints.forEach { (node) in
            result += dimension.maxWidth(node, orValue: 0)
        }
        return result
    }

    override class func height(forNode: WOTNodeProtocol, dimension: WOTPivotDimensionProtocol) -> Int {
        return 1
    }
}

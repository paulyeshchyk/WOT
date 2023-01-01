//
//  WOTDimensionRowCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class RowPivotDimensionCalculator: PivotDimensionCalculator {
    override class func x(forNode: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return NodeEnumerator.sharedInstance.visibleParentsCount(node: forNode)
    }

    override class func y(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        var result: Int = NodeEnumerator.sharedInstance.childrenWidth(siblingNode: forNode, orValue: 1)
        result += dimension.rootNodeHeight
        return result
    }

    override class func width(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 1
    }

    override class func height(forNode: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return NodeEnumerator.sharedInstance.endpoints(node: forNode)?.count ?? 0
    }
}

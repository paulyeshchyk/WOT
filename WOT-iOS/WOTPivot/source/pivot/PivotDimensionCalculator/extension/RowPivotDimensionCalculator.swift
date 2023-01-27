//
//  WOTDimensionRowCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

public class RowPivotDimensionCalculator: PivotDimensionCalculator {
    //

    override class func x(forNode: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return NodeEnumerator().visibleParentsCount(node: forNode)
    }

    override class func y(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        var result: Int = NodeEnumerator().childrenWidth(siblingNode: forNode, orValue: 1)
        result += dimension.rootNodeHeight
        return result
    }

    override class func width(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 1
    }

    override class func height(forNode: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return NodeEnumerator().endpoints(node: forNode)?.count ?? 0
    }
}

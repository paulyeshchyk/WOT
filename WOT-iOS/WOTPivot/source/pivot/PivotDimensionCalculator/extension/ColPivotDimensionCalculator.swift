//
//  WOTDimensionColumnCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

public class ColPivotDimensionCalculator: PivotDimensionCalculator {
    //

    override class func x(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        var result: Int = dimension.childrenMaxWidth(forNode, orValue: 0)
        result += dimension.rootNodeWidth
        return result
    }

    override class func y(forNode: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return NodeEnumerator().visibleParentsCount(node: forNode)
    }

    override class func width(forNode: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        let endpoints = NodeEnumerator().endpoints(node: forNode)
        let cnt = endpoints?.count ?? 0
        guard cnt > 0 else {
            return 1
        }

        var result: Int = 0
        endpoints?.forEach { (node) in
            result += dimension.maxWidth(node, orValue: 0)
        }
        return result
    }

    override class func height(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 1
    }
}

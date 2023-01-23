//
//  WOTDimensionFilterCalculator.swift
//  WOT-iOS
//
//  Created on 7/16/18.
//  Copyright © 2018. All rights reserved.
//

public class FilterPivotDimensionCalculator: PivotDimensionCalculator {
    override class func x(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 0
    }

    override class func y(forNode _: NodeProtocol, dimension _: PivotNodeDimensionProtocol) -> Int {
        return 0
    }

    override class func width(forNode _: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        return dimension.rootNodeWidth
    }

    override class func height(forNode _: NodeProtocol, dimension: PivotNodeDimensionProtocol) -> Int {
        return dimension.rootNodeHeight
    }
}

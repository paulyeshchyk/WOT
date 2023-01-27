//
//  FilterPivotNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

public class FilterPivotNode: PivotNode {
    override public var stickyType: PivotStickyType {
        let vertical = PivotStickyType.vertical().rawValue
        let horizontal = PivotStickyType.horizontal().rawValue
        return PivotStickyType(rawValue: vertical | horizontal)
    }

    override public var cellType: PivotCellType {
        return .filter
    }
}

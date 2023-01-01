//
//  RowPivotNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

public class RowPivotNode: PivotNode {
    override public var stickyType: PivotStickyType {
        return PivotStickyType.horizontal
    }

    override public var cellType: PivotCellType {
        return .row
    }
}

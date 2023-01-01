//
//  ColPivotNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class ColPivotNode: PivotNode {
    override public var stickyType: PivotStickyType {
        return PivotStickyType.vertical
    }

    override public var cellType: PivotCellType {
        return .column
    }
}

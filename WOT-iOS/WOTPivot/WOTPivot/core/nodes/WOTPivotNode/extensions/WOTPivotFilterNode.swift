//
//  WOTPivotFilterNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTPivotFilterNode: WOTPivotNode {

    override public var stickyType: PivotStickyType {
        let horizontal = UInt8(PivotStickyType.horizontal.rawValue)
        let vertical = UInt8(PivotStickyType.vertical.rawValue)
        let raw = PivotStickyType.RawValue(horizontal | vertical)
        return PivotStickyType(rawValue: raw)!
    }

    override public var cellType: WOTPivotCellType {
        return .filter
    }
}

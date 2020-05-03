//
//  WOTPivotRowNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTPivotRowNode: WOTPivotNode {
    override public var stickyType: PivotStickyType {
        return PivotStickyType.horizontal
    }

    override public var cellType: WOTPivotCellType {
        return .row
    }
}

//
//  WOTPivotRowNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

class WOTPivotRowNode: WOTPivotNode {

    override var stickyType: PivotStickyType {

        return PivotStickyType.horizontal
    }

    override var cellType: WOTPivotCellType {
        return .row
    }
}

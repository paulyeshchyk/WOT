//
//  WOTPivotFilterNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

class WOTPivotFilterNodeSwift: WOTPivotNodeSwift {

    override var stickyType: PivotStickyType {
//        return PivotStickyTypeHorizontal | PivotStickyTypeVertical;
        return (PivotStickyType(rawValue: PivotStickyType.RawValue(UInt8(PivotStickyType.horizontal.rawValue) | UInt8(PivotStickyType.vertical.rawValue))))!
    }
}

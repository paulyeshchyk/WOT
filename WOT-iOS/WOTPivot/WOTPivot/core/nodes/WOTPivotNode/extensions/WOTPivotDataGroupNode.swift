//
//  WOTPivotDataGroupNode.swift
//  WOT-iOS
//
//  Created on 8/13/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTPivotDataGroupNode: WOTPivotNode {

    @objc
    public var fetchedObjects: [AnyObject]?

    override public var cellType: WOTPivotCellType {
        return .dataGroup
    }

}

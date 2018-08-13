//
//  WOTPivotDataGroupNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/13/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

class WOTPivotDataGroupNode: WOTPivotNode {

    @objc
    var fetchedObjects:[AnyObject]?
    
    override var cellType: WOTPivotCellType {
        return .dataGroup
    }

}

//
//  DataGroupPivotNode.swift
//  WOT-iOS
//
//  Created on 8/13/18.
//  Copyright © 2018. All rights reserved.
//

public class DataGroupPivotNode: PivotNode {
    @objc
    public var fetchedObjects: [AnyObject]?

    override public var cellType: PivotCellType {
        return .dataGroup
    }
}

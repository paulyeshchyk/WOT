//
//  ColPivotNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

public class ColPivotNode: PivotNode {

    public required init(name nameValue: String, predicate predicateValue: NSPredicate) {
        super.init(name: nameValue, predicate: predicateValue)
    }

    @objc public required init(name: String) {
        super.init(name: name)
    }

    override public var stickyType: PivotStickyType {
        return PivotStickyType.vertical
    }

    override public var cellType: PivotCellType {
        return .column
    }
}

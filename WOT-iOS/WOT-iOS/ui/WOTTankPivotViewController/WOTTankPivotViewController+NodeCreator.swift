//
//  WOTTankPivotViewController+NodeCreator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/6/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: WOTNodeCreatorProtocol {

    public func createNode(name: String) -> WOTNodeProtocol {
        let result = WOTNode(name: name)
        result.isVisible = false
        return result
    }

    public func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {

        return WOTNodeFactory.pivotDataNode(for: byPredicate, andTanksObject: fetchedObject as Any)
    }

}

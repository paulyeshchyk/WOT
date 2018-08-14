//
//  WOTTankPivotViewController+NodeCreator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/6/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: WOTNodeCreatorProtocol {

    var collapseToGroups: Bool { return true }

    public func createNode(name: String) -> WOTNodeProtocol {
        let result = WOTNode(name: name)
        result.isVisible = false
        return result
    }

    public func createNodeGroup(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol {

        return WOTNodeFactory.pivotDataNodeGroup(for: byPredicate, andTanksObjects: fetchedObjects)
    }

    public func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {

        return WOTNodeFactory.pivotDataNode(for: byPredicate, andTanksObject: fetchedObject as Any)
    }

    public func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [WOTNodeProtocol] {

        var result = [WOTNodeProtocol]()
        if fetchedObjects.count < 2 || self.collapseToGroups == false {
            fetchedObjects.forEach { (fetchedObject) in
                if let fetchObj = fetchedObject as? NSFetchRequestResult {
                    let node = self.createNode(fetchedObject: fetchObj, byPredicate: byPredicate)
                    result.append(node)
                }
            }
        } else {
            let node = self.createNodeGroup(fetchedObjects: fetchedObjects, byPredicate: byPredicate)
            result.append(node)
        }

        return result
    }
}

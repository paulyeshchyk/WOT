//
//  WOTTankPivotNodeCreator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

open class WOTPivotNodeCreator: WOTNodeCreatorProtocol {
    open var collapseToGroups: Bool { return false }

    open var useEmptyNode: Bool { return false }

    public init() {}

    open func createEmptyNode() -> WOTNodeProtocol {
        return WOTPivotDataNode(name: "")
    }

    open func createNode(name: String) -> WOTNodeProtocol {
        let result = WOTNode(name: name)
        result.isVisible = false
        return result
    }

    open func createNodeGroup(name: String = "Group1", fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol {
        let result = WOTPivotDataGroupNode(name: name)
        result.fetchedObjects = fetchedObjects
        return result
    }

    open func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {
        return WOTPivotDataNode(name: "noname")
    }

    open func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [WOTNodeProtocol] {
        var result = [WOTNodeProtocol]()
        let cnt = fetchedObjects.count

        if cnt == 0 {
            if useEmptyNode {
                let node = self.createEmptyNode()
                result.append(node)
                return result
            } else {
                return result
            }
        }

        if cnt == 1 {
            fetchedObjects.forEach { (fetchedObject) in
                if let fetchObj = fetchedObject as? NSFetchRequestResult {
                    let node = self.createNode(fetchedObject: fetchObj, byPredicate: byPredicate)
                    result.append(node)
                }
            }
            return result
        } else {
            let hasMoreThenOne = (cnt > 1)
            if self.collapseToGroups && hasMoreThenOne  {
                let node = self.createNodeGroup(fetchedObjects: fetchedObjects, byPredicate: byPredicate)
                result.append(node)
                return result
            }

            fetchedObjects.forEach { (fetchedObject) in
                if let fetchObj = fetchedObject as? NSFetchRequestResult {
                    let node = self.createNode(fetchedObject: fetchObj, byPredicate: byPredicate)
                    result.append(node)
                }
            }
            return result
        }
    }
}

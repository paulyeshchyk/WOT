//
//  WOTTankPivotViewController+NodeCreator.swift
//  WOT-iOS
//
//  Created on 8/6/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import WOTPivot

extension WOTTankPivotViewController: WOTNodeCreatorProtocol {

    var collapseToGroups: Bool { return true }

    var useEmptyNode: Bool { return false }

    func createEmptyNode() -> WOTNodeProtocol {

        return WOTNodeFactory.pivotEmptyNode()
    }

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

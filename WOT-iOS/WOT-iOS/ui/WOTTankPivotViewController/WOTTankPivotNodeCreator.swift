//
//  WOTTankPivotNodeCreator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTData

public class WOTTankPivotNodeCreator: WOTNodeCreatorProtocol {

    public var collapseToGroups: Bool { return true }

    public var useEmptyNode: Bool { return false }

    public init() {
        
    }
    
    public func createEmptyNode() -> WOTNodeProtocol {
        return WOTPivotDataNode(name: "")
    }

    public func createNode(name: String) -> WOTNodeProtocol {
        let result = WOTNode(name: name)
        result.isVisible = false
        return result
    }

    public func createNodeGroup(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol {
        let result = WOTPivotDataGroupNode(name: "Group1")
        result.fetchedObjects = fetchedObjects
        return result
    }

    public func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {
        let name = (fetchedObject as? Vehicles)?.name ?? ""
        let type = (fetchedObject as? Vehicles)?.type ?? ""
        let color = WOTNodeFactory.typeColors()[type] as? UIColor
        let result = WOTPivotDataNode(name: name)
        result.predicate = byPredicate
        result.data1 = fetchedObject
        result.dataColor = color
        return result
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

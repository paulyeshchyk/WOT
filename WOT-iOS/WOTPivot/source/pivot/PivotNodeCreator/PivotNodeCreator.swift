//
//  PivotNodeCreator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class PivotNodeCreator: NodeCreatorProtocol {

    public init() {
        //
    }

    open var collapseToGroups: Bool { return false }

    open var useEmptyNode: Bool { return false }

    open func createEmptyNode() -> NodeProtocol {
        return DataPivotNode(name: "")
    }

    open func createNode(name: String) -> NodeProtocol {
        let result = Node(name: name)
        result.isVisible = false
        return result
    }

    open func createNodeGroup(name: String = "Group1", fetchedObjects: [AnyObject], byPredicate _: NSPredicate?) -> NodeProtocol {
        let result = DataGroupPivotNode(name: name)
        result.fetchedObjects = fetchedObjects
        return result
    }

    open func createNode(fetchedObject _: AnyObject?, byPredicate _: NSPredicate?) -> NodeProtocol {
        return DataPivotNode(name: "noname")
    }

    open func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [NodeProtocol] {
        let cnt = fetchedObjects.count

        if cnt == 0 {
            if useEmptyNode {
                let node = createEmptyNode()
                return [node]
            } else {
                return []
            }
        } else if cnt == 1 {
            return nodes(for: fetchedObjects, byPredicate: byPredicate)
        } else {
            if collapseToGroups {
                let node = createNodeGroup(fetchedObjects: fetchedObjects, byPredicate: byPredicate)
                return [node]
            } else {
                return nodes(for: fetchedObjects, byPredicate: byPredicate)
            }
        }
    }

    private func nodes(for fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [NodeProtocol] {
        var result = [NodeProtocol]()
        fetchedObjects.forEach { (fetchedObject) in
            let node = self.createNode(fetchedObject: fetchedObject, byPredicate: byPredicate)
            result.append(node)
        }
        return result
    }
}

//
//  JSONNodeIndex.swift
//  WOT-iOS
//
//  Created on 7/12/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import WOTKit

@objc
public class JSONNodeIndex: NSObject, NodeIndexProtocol {
    // contains node.index: node
    // where node.index - global autoincremented value
    // used to get item by indexpath while iterating in  WOTPivotLayout::layoutAttributesForElementsInRect

    private var index = JSON()

    public func reset() {
        index.removeAll()
    }

    public func add(nodes: [NodeProtocol], level: NodeLevelType) {
        nodes.forEach { (node) in
            self.add(node: node, level: level)
        }
    }

    public func add(node: NodeProtocol, level _: NodeLevelType) {
        let allItems = NodeEnumerator.sharedInstance.allItems(fromNode: node)
        allItems.forEach { (node) in
            index[node.index] = node
        }
    }

    public var count: Int {
        return index.keys.count
    }

    public func item(indexPath: NSIndexPath) -> NodeProtocol? {
        return index[indexPath.row] as? NodeProtocol
    }

    static let NodeEmptyComparator: NodeComparatorType = { (_, _, _) in
        return .orderedSame
    }

    public func doAutoincrementIndex(forNodes: [NodeProtocol]) -> Int {
        var result: Int = 0
        forNodes.forEach { (node) in
            NodeEnumerator.sharedInstance.enumerateAll(node: node, comparator: JSONNodeIndex.NodeEmptyComparator) { (node) in
                node.index = result
                result += 1
            }
        }
        return result
    }
}

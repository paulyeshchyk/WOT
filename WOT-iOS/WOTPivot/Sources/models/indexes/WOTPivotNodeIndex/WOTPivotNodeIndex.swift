//
//  WOTNodeIndex.swift
//  WOT-iOS
//
//  Created on 7/12/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import WOTKit

class WOTPivotNodeIndex: WOTPivotNodeIndexProtocol {
    // contains node.index: node
    // where node.index - global autoincremented value
    // used to get item by indexpath while iterating in  WOTPivotLayout::layoutAttributesForElementsInRect

    private var index = JSON()

    func reset() {
        index.removeAll()
    }

    func add(nodes: [WOTNodeProtocol], level: NodeLevelType) {
        nodes.forEach { (node) in
            self.add(node: node, level: level)
        }
    }

    func add(node: WOTNodeProtocol, level _: NodeLevelType) {
        let allItems = WOTNodeEnumerator.sharedInstance.allItems(fromNode: node)
        allItems.forEach { (node) in
            index[node.index] = node
        }
    }

    var count: Int {
        return index.keys.count
    }

    func item(indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return index[indexPath.row] as? WOTNodeProtocol
    }

    static let WOTNodeEmptyComparator: WOTNodeComparatorType = { (_, _, _) in
        return .orderedSame
    }

    func doAutoincrementIndex(forNodes: [WOTNodeProtocol]) -> Int {
        var result: Int = 0
        forNodes.forEach { (node) in
            WOTNodeEnumerator.sharedInstance.enumerateAll(node: node, comparator: WOTPivotNodeIndex.WOTNodeEmptyComparator) { (node) in
                node.index = result
                result += 1
            }
        }
        return result
    }
}

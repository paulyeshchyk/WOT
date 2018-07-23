//
//  WOTNodeIndex.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/12/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTNodeIndexProtocol: NSObjectProtocol {
    func reset()
    func addNodeToIndex(_ node: WOTNodeProtocol)
    func addNodesToIndex(_ nodes: [WOTNodeProtocol])
    var count: Int { get }
    func item(indexPath: NSIndexPath) -> WOTNodeProtocol?
    func maxWidthOrValue(_ value: Int) -> Int
    func doAutoincrementIndex(forNodes: [WOTNodeProtocol]) -> Int
}

@objc
class WOTNodeIndex: NSObject, WOTNodeIndexProtocol {

    // contains node.index: node
    // where node.index - global autoincremented value
    // used to get item by indexpath while iterating in  WOTTankPivotLayout::layoutAttributesForElementsInRect

    private var index = [AnyHashable: Any] ()

    func maxWidthOrValue(_ value: Int) -> Int {
        return 0
    }

    func reset() {
        index.removeAll()
    }

    func addNodesToIndex(_ nodes: [WOTNodeProtocol]) {
        nodes.forEach { (node) in
            self.addNodeToIndex(node)
        }
    }

    func addNodeToIndex(_ node: WOTNodeProtocol) {
        let allItems = WOTNodeEnumerator.sharedInstance.allItems(fromNode: node)
        allItems.forEach { (node) in
            index[node.index] = node
        }
    }

    var count: Int {
        return self.index.keys.count
    }

    func item(indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return self.index[indexPath.row] as? WOTNodeProtocol
    }

    func doAutoincrementIndex(forNodes: [WOTNodeProtocol]) -> Int {
        var result: Int = 0
        forNodes.forEach { (node) in
            WOTNodeEnumerator.sharedInstance.enumerateAll(node: node, comparator: WOTPivotNodeSwift.WOTNodeEmptyComparator) { (node) in
                node.index = result
                result += 1
            }
        }
        return result
    }
}
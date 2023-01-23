//
//  NodeIndex.swift
//  WOT-iOS
//
//  Created on 7/12/18.
//  Copyright © 2018. All rights reserved.
//

// MARK: - NodeIndex

public class NodeIndex: NSObject, NodeIndexProtocol {

    public static let Comparator: NodeComparatorType = { (_, _, _) in
        return .orderedSame
    }

    public var count: Int {
        return index.keys.count
    }

    private var index = [AnyHashable: NodeProtocol]()

    // MARK: Lifecycle

    // contains node.index: node
    // where node.index - global autoincremented value
    // used to get item by indexpath while iterating in  WOTPivotLayout::layoutAttributesForElementsInRect

    override public required init() {
        //
        super.init()
    }

    deinit {
        //
    }

    // MARK: Public

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

    public func item(indexPath: IndexPath) -> NodeProtocol? {
        return index[indexPath.row]
    }

    public func doAutoincrementIndex(forNodes nodes: [NodeProtocol]) -> Int {
        var result: Int = 0
        nodes.forEach { (node) in
            NodeEnumerator.sharedInstance.enumerateAll(node: node, comparator: NodeIndex.Comparator) { (node) in
                node.index = result
                result += 1
            }
        }
        return result
    }

}

// MARK: - ObjCNodeIndex

@objc
public class ObjCNodeIndex: NSObject {
    @objc
    public static let defaultIndex: NodeIndexProtocol = NodeIndex()
}

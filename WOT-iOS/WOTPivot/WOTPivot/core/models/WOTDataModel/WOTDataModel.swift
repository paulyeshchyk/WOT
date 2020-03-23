//
//  WOTDataModel.swift
//  WOT-iOS
//
//  Created on 7/11/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
open class WOTDataModel: NSObject, WOTDataModelProtocol {
    lazy public var nodeIndex: WOTPivotNodeIndexProtocol = { return WOTPivotNodeIndex() }()
    lazy public var rootNodes: [WOTNodeProtocol] = { return [] }()
    private var comparator: WOTNodeComparator = { (left, right) in return true }

    public var endpointsCount: Int {
        return self.enumerator?.endpoints(array: rootNodes).count ?? 0
    }

    open var nodes: [WOTNodeProtocol] { return [] }

    public var enumerator: WOTNodeEnumeratorProtocol?

    open func loadModel() {
        self.reindexNodes()
    }

    public func reindexNodes() {
        self.nodeIndex.reset()
        self.nodeIndex.add(nodes: self.nodes, level: nil)
    }

    public func add(nodes: [WOTNodeProtocol]) {
        nodes.forEach { (node) in
            self.rootNodes.append(node)
        }
    }

    public func add(rootNode: WOTNodeProtocol) {
        self.rootNodes.append(rootNode)
    }

    public func remove(rootNode: WOTNodeProtocol) {
        guard let index = (self.rootNodes.index { $0 === rootNode }) else {
            return
        }
        self.rootNodes.remove(at: index)
    }

    open func clearRootNodes() {
        self.rootNodes.removeAll()
    }

    public func rootNodes(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(self.rootNodes).sorted(by: comparator)
    }

    #warning("check")
    public func nodesCount(section: Int) -> Int {
        return 0
    }

    #warning("check")
    public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return self.nodeIndex.item(indexPath: indexPath)
    }

    #warning("check")
    public func indexPath(forNode: WOTNodeProtocol?) -> IndexPath? {
        return nil
    }
}

//
//  WOTDataModel.swift
//  WOT-iOS
//
//  Created on 7/11/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import WOTKit

open class WOTDataModel: NSObject, WOTDataModelProtocol {
    public lazy var nodeIndex: WOTPivotNodeIndexProtocol = { return WOTPivotNodeIndex() }()
    public lazy var rootNodes: [WOTNodeProtocol] = { return [] }()
    private var comparator: WOTNodeComparator = { (_, _) in return true }

    public var endpointsCount: Int {
        return self.enumerator?.endpoints(array: rootNodes).count ?? 0
    }

    open var nodes: [WOTNodeProtocol] { return [] }

    public var enumerator: WOTNodeEnumeratorProtocol?

    open func loadModel() {
        reindexNodes()
    }

    open func cancelLoad(reason _: RequestCancelReasonProtocol) {
        assertionFailure("should be overriden")
    }

    public func reindexNodes() {
        nodeIndex.reset()
        nodeIndex.add(nodes: nodes, level: NodeLevelTypeZero)
    }

    public func add(nodes: [WOTNodeProtocol]) {
        nodes.forEach { (node) in
            self.rootNodes.append(node)
        }
    }

    public func add(rootNode: WOTNodeProtocol) {
        rootNodes.append(rootNode)
    }

    public func remove(rootNode: WOTNodeProtocol) {
        guard let index = (rootNodes.firstIndex { $0 === rootNode }) else {
            return
        }
        rootNodes.remove(at: index)
    }

    open func clearRootNodes() {
        rootNodes.removeAll()
    }

    public func rootNodes(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(rootNodes).sorted(by: comparator)
    }

    public func nodesCount(section _: Int) -> Int {
        return 0
    }

    public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return nodeIndex.item(indexPath: indexPath)
    }

    public func indexPath(forNode _: WOTNodeProtocol?) -> IndexPath? {
        return nil
    }
}

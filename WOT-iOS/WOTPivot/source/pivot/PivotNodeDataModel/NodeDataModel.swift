//
//  PivotNodeDataModel.swift
//  WOT-iOS
//
//  Created on 7/11/18.
//  Copyright © 2018. All rights reserved.
//

@objc
open class NodeDataModel: NSObject, NodeDataModelProtocol {
    public var nodeIndex: NodeIndexProtocol
    public lazy var rootNodes: [NodeProtocol] = { return [] }()
    private var comparator: NodeComparator = { (_, _) in return true }

    public var endpointsCount: Int {
        return self.enumerator?.endpoints(array: rootNodes).count ?? 0
    }

    open var nodes: [NodeProtocol] { return [] }

    public var enumerator: NodeEnumeratorProtocol?

    public required init(nodeIndex: NodeIndexProtocol) {
        self.nodeIndex = nodeIndex
        super.init()
    }

    open func loadModel() {
        reindexNodes()
    }

    public func reindexNodes() {
        nodeIndex.reset()
        nodeIndex.add(nodes: nodes, level: NodeLevelTypeZero)
    }

    public func add(nodes: [NodeProtocol]) {
        nodes.forEach { (node) in
            self.rootNodes.append(node)
        }
    }

    public func add(rootNode: NodeProtocol) {
        rootNodes.append(rootNode)
    }

    public func remove(rootNode: NodeProtocol) {
        guard let index = (rootNodes.firstIndex { $0 === rootNode }) else {
            return
        }
        rootNodes.remove(at: index)
    }

    open func clearRootNodes() {
        rootNodes.removeAll()
    }

    public func rootNodes(sortComparator: NodeComparator?) -> [NodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(rootNodes).sorted(by: comparator)
    }

    public func nodesCount(section _: Int) -> Int {
        return 0
    }

    public func node(atIndexPath indexPath: NSIndexPath) -> NodeProtocol? {
        return nodeIndex.item(indexPath: indexPath)
    }

    public func indexPath(forNode _: NodeProtocol?) -> IndexPath? {
        return nil
    }
}

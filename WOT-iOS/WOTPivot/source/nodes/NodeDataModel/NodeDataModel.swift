//
//  PivotNodeDataModel.swift
//  WOT-iOS
//
//  Created on 7/11/18.
//  Copyright © 2018. All rights reserved.
//

@objc
open class NodeDataModel: NSObject, NodeDataModelProtocol {

    open var nodes: [NodeProtocol] { return [] }

    public var nodeIndex: NodeIndexProtocol
    public lazy var rootNodes: [NodeProtocol] = { return [] }()

    let enumerator = NodeEnumerator()

    public var endpointsCount: Int {
        return enumerator.endpoints(array: rootNodes).count
    }

    private var comparator: NodeComparator = { (_, _) in return true }

    // MARK: Lifecycle

    public required init(nodeIndexType: NodeIndexProtocol.Type) {
        nodeIndex = nodeIndexType.init()
        super.init()
    }

    // MARK: Open

    open func loadModel() {
        reindexNodes()
        clearRootNodes()
    }

    open func clearRootNodes() {
        rootNodes.removeAll()
    }

    // MARK: Public

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

    public func rootNodes(sortComparator: NodeComparator?) -> [NodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(rootNodes).sorted(by: comparator)
    }

    public func nodesCount(section _: Int) -> Int {
        return 0
    }

    public func node(atIndexPath: IndexPath) -> NodeProtocol? {
        return nodeIndex.item(indexPath: atIndexPath)
    }

    public func indexPath(forNode _: NodeProtocol?) -> IndexPath? {
        return nil
    }
}

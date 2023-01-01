//
//  TreeDataModel.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class TreeDataModel: NodeDataModel, TreeDataModelProtocol {
    lazy var nodeConnectorIndex: TreeConnectorNodeIndexProtocol = { return TreeConnectorNodeIndex() }()
    public var levels: Int {
        return nodeConnectorIndex.levels
    }

    public var width: Int {
        return self.nodeConnectorIndex.width
    }

    override public func loadModel() {
        super.loadModel()

        reindexNodeConnectors()

        do {
            try fetchController.performFetch(nodeCreator: nodeCreator)
        } catch let error {
            fetchFailed(by: self.fetchController, withError: error)
        }
    }

    var fetchController: NodeFetchControllerProtocol
    var listener: NodeDataModelListener
    var nodeCreator: NodeCreatorProtocol

    public required init(fetchController fetch: NodeFetchControllerProtocol, listener list: NodeDataModelListener, enumerator _: NodeEnumeratorProtocol, nodeCreator nc: NodeCreatorProtocol, nodeIndex ni: NodeIndexProtocol) {
        fetchController = fetch
        listener = list
        nodeCreator = nc
        super.init(nodeIndex: ni)
        fetchController.setFetchListener(self)
    }

    deinit {
        fetchController.setFetchListener(nil)
    }

    public required init(enumerator _: NodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    public required init(nodeIndex _: NodeIndexProtocol) {
        fatalError("init(nodeIndex:) has not been implemented")
    }

    override public func nodesCount(section: Int) -> Int {
        return nodeConnectorIndex.itemsCount(atLevel: section)
    }

    override public func node(atIndexPath indexPath: NSIndexPath) -> NodeProtocol? {
        return nodeConnectorIndex.item(indexPath: indexPath)
    }

    override public func indexPath(forNode: NodeProtocol?) -> IndexPath? {
        guard let node = forNode else {
            return nil
        }
        return nodeConnectorIndex.indexPath(forNode: node)
    }

    override public func add(rootNode: NodeProtocol) {
        super.add(rootNode: rootNode)
        reindexNodeConnectors()
    }

    override public func add(nodes: [NodeProtocol]) {
        super.add(nodes: nodes)
        reindexNodeConnectors()
    }

    override public func remove(rootNode: NodeProtocol) {
        super.remove(rootNode: rootNode)
        reindexNodeConnectors()
    }

    override open func clearRootNodes() {
        super.clearRootNodes()
        reindexNodeConnectors()
    }

    fileprivate func failPivot(_ error: Error) {
        listener.didFinishLoadModel(error: error)
    }

    fileprivate func makeTree(_ fetchController: NodeFetchControllerProtocol, nodeCreator: NodeCreatorProtocol?) {
        fetchController.fetchedNodes(byPredicates: [], nodeCreator: nodeCreator, filteredCompletion: { _, fetchedNodes in
            let data = fetchedNodes?.compactMap { $0 as? Node } ?? []
            self.add(nodes: data)
            self.listener.didFinishLoadModel(error: nil)
        })
    }
}

extension TreeDataModel {
    func reindexNodeConnectors() {
        nodeConnectorIndex.reset()

        let nodes = rootNodes(sortComparator: nil)
        nodeConnectorIndex.add(nodes: nodes, level: NodeLevelTypeZero)
    }
}

extension TreeDataModel: NodeFetchControllerListenerProtocol {
    public func fetchPerformed(by fetchController: NodeFetchControllerProtocol) {
        makeTree(fetchController, nodeCreator: nodeCreator)
    }

    public func fetchFailed(by _: NodeFetchControllerProtocol, withError: Error) {
        failPivot(withError)
    }
}

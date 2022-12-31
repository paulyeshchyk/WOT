//
//  WOTTreeDataModel.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTTreeDataModel: WOTDataModel, WOTTreeDataModelProtocol {
    lazy var nodeConnectorIndex: WOTTreeConnectorNodeIndexProtocol = { return WOTTreeConnectorNodeIndex() }()
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

    var fetchController: WOTDataFetchControllerProtocol
    var listener: WOTDataModelListener
    var nodeCreator: WOTNodeCreatorProtocol

    public required init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener, enumerator _: WOTNodeEnumeratorProtocol, nodeCreator nc: WOTNodeCreatorProtocol) {
        fetchController = fetch
        listener = list
        nodeCreator = nc
        super.init()
        fetchController.setFetchListener(self)
    }

    deinit {
        fetchController.setFetchListener(nil)
    }

    public required init(enumerator _: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    override public func nodesCount(section: Int) -> Int {
        return nodeConnectorIndex.itemsCount(atLevel: section)
    }

    override public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return nodeConnectorIndex.item(indexPath: indexPath)
    }

    override public func indexPath(forNode: WOTNodeProtocol?) -> IndexPath? {
        guard let node = forNode else {
            return nil
        }
        return nodeConnectorIndex.indexPath(forNode: node)
    }

    override public func add(rootNode: WOTNodeProtocol) {
        super.add(rootNode: rootNode)
        reindexNodeConnectors()
    }

    override public func add(nodes: [WOTNodeProtocol]) {
        super.add(nodes: nodes)
        reindexNodeConnectors()
    }

    override public func remove(rootNode: WOTNodeProtocol) {
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

    fileprivate func makeTree(_ fetchController: WOTDataFetchControllerProtocol, nodeCreator: WOTNodeCreatorProtocol?) {
        fetchController.fetchedNodes(byPredicates: [], nodeCreator: nodeCreator, filteredCompletion: { _, fetchedNodes in
            let data = fetchedNodes?.compactMap { $0 as? WOTNode } ?? []
            self.add(nodes: data)
            self.listener.didFinishLoadModel(error: nil)
        })
    }
}

extension WOTTreeDataModel {
    func reindexNodeConnectors() {
        nodeConnectorIndex.reset()

        let nodes = rootNodes(sortComparator: nil)
        nodeConnectorIndex.add(nodes: nodes, level: NodeLevelTypeZero)
    }
}

extension WOTTreeDataModel: WOTDataFetchControllerListenerProtocol {
    public func fetchPerformed(by fetchController: WOTDataFetchControllerProtocol) {
        makeTree(fetchController, nodeCreator: nodeCreator)
    }

    public func fetchFailed(by _: WOTDataFetchControllerProtocol, withError: Error) {
        failPivot(withError)
    }
}

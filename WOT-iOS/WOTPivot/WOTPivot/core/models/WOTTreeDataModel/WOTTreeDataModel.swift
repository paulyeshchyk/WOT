//
//  WOTTreeDataModel.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTTreeDataModel: WOTDataModel, WOTTreeDataModelProtocol {

    lazy var nodeConnectorIndex: WOTConnectorNodeIndex = { return WOTConnectorNodeIndex() }()
    public var levels: Int {
        return self.nodeConnectorIndex.levels
    }
    public var width: Int {
        return self.nodeConnectorIndex.width
    }

    override public func loadModel() {
        super.loadModel()

        self.reindexNodeConnectors()

        do {
            try self.fetchController.performFetch(nodeCreator: nodeCreator)
        } catch let error {
            fetchFailed(by: self.fetchController, withError: error)
        }
    }

    var fetchController: WOTDataFetchControllerProtocol
    var listener: WOTDataModelListener
    var nodeCreator: WOTNodeCreatorProtocol

    required public init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener, enumerator: WOTNodeEnumeratorProtocol, nodeCreator nc: WOTNodeCreatorProtocol) {
        fetchController = fetch
        listener = list
        nodeCreator = nc
        super.init()
        fetchController.setFetchListener(self)
    }

    public required init(enumerator enumer: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    override public func nodesCount(section: Int) -> Int {
        return self.nodeConnectorIndex.itemsCount(atLevel: section)
    }

    override public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return self.nodeConnectorIndex.item(indexPath: indexPath)
    }

    override public func indexPath(forNode: WOTNodeProtocol?) -> IndexPath? {
        guard let node = forNode else {
            return nil
        }
        return self.nodeConnectorIndex.indexPath(forNode: node)
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
        listener.modelDidFailLoad(error: error)
    }

    fileprivate func makeTree(_ fetchController: WOTDataFetchControllerProtocol, nodeCreator: WOTNodeCreatorProtocol?) {
        fetchController.fetchedNodes(byPredicates: [], nodeCreator: nodeCreator, filteredCompletion: { predicate, fetchedNodes in
            let data = fetchedNodes?.compactMap { $0 as? WOTNode } ?? []
            self.add(nodes: data)
            self.listener.modelDidLoad()
        })
    }
}

extension WOTTreeDataModel {
    
    func reindexNodeConnectors() {
        self.nodeConnectorIndex.reset()

        let nodes = self.rootNodes(sortComparator: nil)
        self.nodeConnectorIndex.add(nodes: nodes, level: nil)
    }
}

extension WOTTreeDataModel: WOTDataFetchControllerListenerProtocol {

    public func fetchPerformed(by fetchController: WOTDataFetchControllerProtocol) {
        self.makeTree(fetchController, nodeCreator: nodeCreator)
    }

    public func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error) {
        self.failPivot(withError)
    }
}

//
//  TreeDataModel.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

// MARK: - TreeDataModel

open class TreeDataModel: NodeDataModel, TreeDataModelProtocol {

    open var levels: Int {
        return nodeConnectorIndex.levels
    }

    open var width: Int {
        return nodeConnectorIndex.width
    }

    private let nodeConnectorIndex: TreeConnectorNodeIndexProtocol = TreeConnectorNodeIndex()
    weak var fetchController: NodeFetchControllerProtocol?
    weak var listener: NodeDataModelListener?
    weak var nodeCreator: NodeCreatorProtocol?

    // MARK: Lifecycle

    public required init(fetchController fetch: NodeFetchControllerProtocol, listener list: NodeDataModelListener, nodeCreator nc: NodeCreatorProtocol, nodeIndex ni: NodeIndexProtocol.Type, appContext: Context) {
        fetchController = fetch
        listener = list
        nodeCreator = nc
        super.init(nodeIndex: ni, appContext: appContext)
        fetchController?.setFetchListener(self)
    }

    public required init(enumerator _: NodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    public required init(nodeIndex _: NodeIndexProtocol.Type, appContext _: Context) {
        fatalError("init(nodeIndex:) has not been implemented")
    }

    deinit {
        fetchController?.setFetchListener(nil)
    }

    // MARK: Public

    override open func loadModel() {
        super.loadModel()

        reindexNodeConnectors()

        do {
            try fetchController?.performFetch(appContext: appContext)
        } catch let error {
            appContext.logInspector?.log(.error(error), sender: self)
            fetchFailed(by: self.fetchController, withError: error)
        }
    }

    override open func nodesCount(section: Int) -> Int {
        return nodeConnectorIndex.itemsCount(atLevel: section)
    }

    override open func node(atIndexPath: IndexPath) -> NodeProtocol? {
        return nodeConnectorIndex.item(indexPath: atIndexPath)
    }

    override open func indexPath(forNode: NodeProtocol?) -> IndexPath? {
        guard let node = forNode else {
            return nil
        }
        return nodeConnectorIndex.indexPath(forNode: node)
    }

    override open func add(rootNode: NodeProtocol) {
        super.add(rootNode: rootNode)
        reindexNodeConnectors()
    }

    override open func add(nodes: [NodeProtocol]) {
        super.add(nodes: nodes)
        reindexNodeConnectors()
    }

    override open func remove(rootNode: NodeProtocol) {
        super.remove(rootNode: rootNode)
        reindexNodeConnectors()
    }

    // MARK: Fileprivate

    fileprivate func failPivot(_ error: Error) {
        listener?.didFinishLoadModel(error: error)
    }

    fileprivate func makeTree(_ fetchController: NodeFetchControllerProtocol, nodeCreator: NodeCreatorProtocol?) {
        fetchController.fetchedNodes(byPredicates: [], nodeCreator: nodeCreator, filteredCompletion: { _, fetchedNodes in
            let data = fetchedNodes?.compactMap { $0 as? Node } ?? []
            self.add(nodes: data)
            self.listener?.didFinishLoadModel(error: nil)
        })
    }
}

// MARK: - %t + TreeDataModel.Errors

extension TreeDataModel {
    enum Errors: Error {
        case noFetchControllerDefined
    }
}

extension TreeDataModel {
    func reindexNodeConnectors() {
        nodeConnectorIndex.reset()

        let nodes = rootNodes(sortComparator: nil)
        nodeConnectorIndex.add(nodes: nodes, level: NodeLevelTypeZero)
    }
}

// MARK: - TreeDataModel + NodeFetchControllerListenerProtocol

extension TreeDataModel: NodeFetchControllerListenerProtocol {
    public func fetchPerformed(by fetchController: NodeFetchControllerProtocol) {
        makeTree(fetchController, nodeCreator: nodeCreator)
    }

    public func fetchFailed(by _: NodeFetchControllerProtocol?, withError: Error) {
        failPivot(withError)
    }
}

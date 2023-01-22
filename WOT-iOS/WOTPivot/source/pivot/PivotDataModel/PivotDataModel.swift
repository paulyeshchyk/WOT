//
//  PivotDataModel.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import UIKit

// MARK: - PivotDataModel

open class PivotDataModel: NodeDataModel, PivotDataModelProtocol, PivotNodeDatasourceProtocol {

    override open var nodes: [NodeProtocol] {
        return [rootFilterNode, rootColsNode, rootRowsNode, rootDataNode]
    }

    public lazy var dimension: PivotNodeDimensionProtocol = {
        let result = PivotNodeDimension(rootNodeHolder: self)
        result.enumerator = enumerator
        result.fetchController = fetchController
        result.listener = self
        return result
    }()

    // WOTPivotNodeHolderProtocol
    public lazy var rootFilterNode: NodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root filters")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootColsNode: NodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root cols")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootRowsNode: NodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root rows")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootDataNode: NodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root data")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootNode: NodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root")
        self.add(rootNode: result)
        return result
    }()

    public var shouldDisplayEmptyColumns: Bool

    public var fetchController: NodeFetchControllerProtocol?
    public var nodeCreator: NodeCreatorProtocol

    override public var enumerator: NodeEnumeratorProtocol? {
        didSet {
            dimension.enumerator = enumerator
        }
    }

    @objc public var contentSize: CGSize {
        return dimension.contentSize
    }

    private var listener: NodeDataModelListener?
    private var metadatasource: PivotMetaDatasourceProtocol

    // MARK: Lifecycle

    @objc public required init(fetchController: NodeFetchControllerProtocol, modelListener: NodeDataModelListener, nodeCreator: NodeCreatorProtocol, metadatasource: PivotMetaDatasourceProtocol, nodeIndex ni: NodeIndexProtocol.Type, appContext: Context) {
        shouldDisplayEmptyColumns = false
        self.fetchController = fetchController
        listener = modelListener
        self.nodeCreator = nodeCreator
        self.metadatasource = metadatasource

        super.init(nodeIndex: ni, appContext: appContext)

        fetchController.setFetchListener(self)

        dimension.registerCalculatorClass(ColPivotDimensionCalculator.self, forNodeClass: ColPivotNode.self)
        dimension.registerCalculatorClass(RowPivotDimensionCalculator.self, forNodeClass: RowPivotNode.self)
        dimension.registerCalculatorClass(FilterPivotDimensionCalculator.self, forNodeClass: FilterPivotNode.self)
        dimension.registerCalculatorClass(DataPivotDimensionCalculator.self, forNodeClass: DataPivotNode.self)
        dimension.registerCalculatorClass(GroupDataPivotDimensionCalculator.self, forNodeClass: DataGroupPivotNode.self)
    }

    public required init(enumerator _: NodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    public required init(nodeIndex _: NodeIndexProtocol.Type, appContext _: Context) {
        fatalError("init(nodeIndex:) has not been implemented")
    }

    deinit {
        clearMetadataItems()
        fetchController?.setFetchListener(nil)
    }

    // MARK: Open

    override open func clearRootNodes() {
        appContext.logInspector?.log(.flow(name: "pivot", message: "Clear root nodes"), sender: self)

        rootDataNode.removeChildren()
        rootRowsNode.removeChildren()
        rootColsNode.removeChildren()
        rootFilterNode.removeChildren()
        super.clearRootNodes()
    }

    override open func reindexNodes() {
        super.reindexNodes()
        appContext.logInspector?.log(.flow(name: "pivot", message: "Reindex nodes"), sender: self)
    }

    override open func loadModel() {
        // super.loadModel()
        appContext.logInspector?.log(.flow(name: "pivot", message: "Start"), sender: self)

        do {
            try fetchController?.performFetch(nodeCreator: nodeCreator, appContext: appContext)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    // MARK: Public

    public func add(dataNode: NodeProtocol) {
        rootDataNode.addChild(dataNode)
    }

    public func itemRect(atIndexPath: IndexPath) -> CGRect {
        guard let node = node(atIndexPath: atIndexPath) as? PivotNodeProtocol else {
            return .zero
        }
        // FIXME: node.relativeRect should be optimized
        guard let relativeRectValue = node.relativeRect else {
            return dimension.pivotRect(forNode: node)
        }

        return relativeRectValue.cgRectValue
    }

    public func itemsCount(section _: Int) -> Int {
        #warning("currently not used")
        /*
         * be sure section is used
         * i.e. for case when two or more section displayed
         *
         */
        let cnt = nodeIndex.count
        return cnt
    }

    public func clearMetadataItems() {
        appContext.logInspector?.log(.flow(name: "pivot", message: "Clear metadata items"), sender: self)

        nodeIndex.reset()
        clearRootNodes()
    }

    public func add(metadataItems: [NodeProtocol]) {
        let rows = metadataItems.compactMap { $0 as? RowPivotNode }
        rootRowsNode.addChildArray(rows)

        let cols = metadataItems.compactMap { $0 as? ColPivotNode }
        rootColsNode.addChildArray(cols)

        let filters = metadataItems.compactMap { $0 as? FilterPivotNode }
        rootFilterNode.addChildArray(filters)
    }

    // MARK: Private

    private func makePivot() {
        clearMetadataItems()

        let items = metadatasource.metadataItems()
        add(metadataItems: items)

        let metadataIndex = nodeIndex.doAutoincrementIndex(forNodes: [rootFilterNode, rootColsNode, rootRowsNode])
        dimension.reload(forIndex: metadataIndex, nodeCreator: nodeCreator)
    }

    private func failPivot(_ error: Error) {
        listener?.didFinishLoadModel(error: error)
    }
}

// MARK: - PivotDataModel + DimensionLoadListenerProtocol

extension PivotDataModel: DimensionLoadListenerProtocol {
    public func didLoad(dimension _: NodeDimensionProtocol) {
        reindexNodes()
        listener?.didFinishLoadModel(error: nil)
        appContext.logInspector?.log(.flow(name: "pivot", message: "End"), sender: self)
    }
}

// MARK: - PivotDataModel + NodeFetchControllerListenerProtocol

extension PivotDataModel: NodeFetchControllerListenerProtocol {
    public func fetchFailed(by _: NodeFetchControllerProtocol, withError: Error) {
        failPivot(withError)
    }

    public func fetchPerformed(by _: NodeFetchControllerProtocol) {
        makePivot()
    }
}

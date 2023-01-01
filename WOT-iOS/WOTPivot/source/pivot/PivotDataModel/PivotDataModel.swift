//
//  PivotDataModel.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import UIKit

open class PivotDataModel: NodeDataModel, PivotDataModelProtocol, PivotNodeDatasourceProtocol {
    public lazy var dimension: PivotNodeDimensionProtocol = {
        let result = PivotNodeDimension(rootNodeHolder: self)
        result.enumerator = enumerator
        result.fetchController = fetchController
        result.listener = self
        return result
    }()

    override public var enumerator: NodeEnumeratorProtocol? {
        didSet {
            dimension.enumerator = enumerator
        }
    }

    @objc
    public var contentSize: CGSize {
        return dimension.contentSize
    }

    public var shouldDisplayEmptyColumns: Bool

    private var listener: NodeDataModelListener?
    private var metadatasource: PivotMetaDatasourceProtocol
    public var fetchController: NodeFetchControllerProtocol?
    public var nodeCreator: NodeCreatorProtocol

    deinit {
        clearMetadataItems()
        fetchController?.setFetchListener(nil)
    }

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

    public func add(dataNode: NodeProtocol) {
        rootDataNode.addChild(dataNode)
    }

    override open var nodes: [NodeProtocol] {
        return [self.rootFilterNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode]
    }

    override open func clearRootNodes() {
        rootDataNode.removeChildren()
        rootRowsNode.removeChildren()
        rootColsNode.removeChildren()
        rootFilterNode.removeChildren()
        super.clearRootNodes()
    }

    public typealias Context = LogInspectorContainerProtocol
    private let appContext: Context

    @objc
    public required init(fetchController: NodeFetchControllerProtocol, modelListener: NodeDataModelListener, nodeCreator: NodeCreatorProtocol, metadatasource: PivotMetaDatasourceProtocol, nodeIndex ni: NodeIndexProtocol, context: Context) {
        shouldDisplayEmptyColumns = false
        self.fetchController = fetchController
        listener = modelListener
        self.nodeCreator = nodeCreator
        self.metadatasource = metadatasource
        appContext = context

        super.init(nodeIndex: ni)

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

    public required init(nodeIndex _: NodeIndexProtocol) {
        fatalError("init(nodeIndex:) has not been implemented")
    }

    override open func loadModel() {
        super.loadModel()

        do {
            try fetchController?.performFetch(nodeCreator: nodeCreator)
        } catch {
            appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
        }
    }

    public func item(atIndexPath: IndexPath) -> PivotNodeProtocol? {
        return (nodeIndex.item(indexPath: atIndexPath) as? PivotNodeProtocol)
    }

    public func itemRect(atIndexPath: IndexPath) -> CGRect {
        guard let node = item(atIndexPath: atIndexPath) else {
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

    fileprivate func makePivot() {
        clearMetadataItems()

        let items = metadatasource.metadataItems()
        add(metadataItems: items)

        let metadataIndex = nodeIndex.doAutoincrementIndex(forNodes: [rootFilterNode, rootColsNode, rootRowsNode])
        dimension.reload(forIndex: metadataIndex, nodeCreator: nodeCreator)
    }

    fileprivate func failPivot(_ error: Error) {
        listener?.didFinishLoadModel(error: error)
    }
}

extension PivotDataModel: DimensionLoadListenerProtocol {
    public func didLoad(dimension _: NodeDimensionProtocol) {
        reindexNodes()
        listener?.didFinishLoadModel(error: nil)
    }
}

extension PivotDataModel: NodeFetchControllerListenerProtocol {
    public func fetchFailed(by _: NodeFetchControllerProtocol, withError: Error) {
        failPivot(withError)
    }

    public func fetchPerformed(by _: NodeFetchControllerProtocol) {
        makePivot()
    }
}

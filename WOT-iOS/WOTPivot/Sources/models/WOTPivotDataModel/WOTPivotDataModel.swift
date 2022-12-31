//
//  WOTPivotTree.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import UIKit

open class WOTPivotDataModel: WOTDataModel, WOTPivotDataModelProtocol, WOTPivotNodeHolderProtocol {
    public lazy var dimension: WOTPivotDimensionProtocol = {
        let result = WOTPivotDimension(rootNodeHolder: self)
        result.enumerator = enumerator
        result.fetchController = fetchController
        result.listener = self
        return result
    }()

    override public var enumerator: WOTNodeEnumeratorProtocol? {
        didSet {
            dimension.enumerator = enumerator
        }
    }

    @objc
    public var contentSize: CGSize {
        return dimension.contentSize
    }

    public var shouldDisplayEmptyColumns: Bool

    private var listener: WOTDataModelListener?
    private var metadatasource: WOTDataModelMetadatasource
    public var fetchController: WOTDataFetchControllerProtocol?
    public var nodeCreator: WOTNodeCreatorProtocol

    deinit {
        clearMetadataItems()
        fetchController?.setFetchListener(nil)
    }

    // WOTPivotNodeHolderProtocol
    public lazy var rootFilterNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root filters")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootColsNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root cols")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootRowsNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root rows")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootDataNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root data")
        self.add(rootNode: result)
        return result
    }()

    public lazy var rootNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root")
        self.add(rootNode: result)
        return result
    }()

    public func add(dataNode: WOTNodeProtocol) {
        rootDataNode.addChild(dataNode)
    }

    override open var nodes: [WOTNodeProtocol] {
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
    public required init(fetchController: WOTDataFetchControllerProtocol, modelListener: WOTDataModelListener, nodeCreator: WOTNodeCreatorProtocol, metadatasource: WOTDataModelMetadatasource, context: Context) {
        shouldDisplayEmptyColumns = false
        self.fetchController = fetchController
        listener = modelListener
        self.nodeCreator = nodeCreator
        self.metadatasource = metadatasource
        appContext = context

        super.init()

        fetchController.setFetchListener(self)

        dimension.registerCalculatorClass(WOTDimensionColumnCalculator.self, forNodeClass: WOTPivotColNode.self)
        dimension.registerCalculatorClass(WOTDimensionRowCalculator.self, forNodeClass: WOTPivotRowNode.self)
        dimension.registerCalculatorClass(WOTDimensionFilterCalculator.self, forNodeClass: WOTPivotFilterNode.self)
        dimension.registerCalculatorClass(WOTDimensionDataCalculator.self, forNodeClass: WOTPivotDataNode.self)
        dimension.registerCalculatorClass(WOTDimensionDataGroupCalculator.self, forNodeClass: WOTPivotDataGroupNode.self)
    }

    public required init(enumerator _: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    override open func loadModel() {
        super.loadModel()

        do {
            try fetchController?.performFetch(nodeCreator: nodeCreator)
        } catch {
            appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
        }
    }

    public func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol? {
        return (nodeIndex.item(indexPath: atIndexPath) as? WOTPivotNodeProtocol)
    }

    public func itemRect(atIndexPath: NSIndexPath) -> CGRect {
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

    public func add(metadataItems: [WOTNodeProtocol]) {
        let rows = metadataItems.compactMap { $0 as? WOTPivotRowNode }
        rootRowsNode.addChildArray(rows)

        let cols = metadataItems.compactMap { $0 as? WOTPivotColNode }
        rootColsNode.addChildArray(cols)

        let filters = metadataItems.compactMap { $0 as? WOTPivotFilterNode }
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

extension WOTPivotDataModel: WOTPivotDimensionListenerProtocol {
    public func didLoad(dimension _: WOTDimensionProtocol) {
        reindexNodes()
        listener?.didFinishLoadModel(error: nil)
    }
}

extension WOTPivotDataModel: WOTTreeProtocol {
    public func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol {
        let roots = rootNodes.filter { _ in forPredicate.evaluate(with: nil) }
        let result = roots.first ?? rootNode
        return result
    }
}

extension WOTPivotDataModel: WOTDataFetchControllerListenerProtocol {
    public func fetchFailed(by _: WOTDataFetchControllerProtocol, withError: Error) {
        failPivot(withError)
    }

    public func fetchPerformed(by _: WOTDataFetchControllerProtocol) {
        makePivot()
    }
}

//
//  WOTPivotTree.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

open class WOTPivotDataModel: WOTDataModel, WOTPivotDataModelProtocol, WOTPivotNodeHolderProtocol {
    lazy public var dimension: WOTPivotDimensionProtocol = {
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
        return self.dimension.contentSize
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
    lazy public var rootFilterNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root filters")
        self.add(rootNode: result)
        return result
    }()

    lazy public var rootColsNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root cols")
        self.add(rootNode: result)
        return result
    }()

    lazy public var rootRowsNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root rows")
        self.add(rootNode: result)
        return result
    }()

    lazy public var rootDataNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root data")
        self.add(rootNode: result)
        return result
    }()

    lazy public var rootNode: WOTNodeProtocol = {
        let result = self.nodeCreator.createNode(name: "root")
        self.add(rootNode: result)
        return result
    }()

    public func add(dataNode: WOTNodeProtocol) {
        self.rootDataNode.addChild(dataNode)
    }

    override open var nodes: [WOTNodeProtocol] {
        return [self.rootFilterNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode]
    }

    override open func clearRootNodes() {
        self.rootDataNode.removeChildren()
        self.rootRowsNode.removeChildren()
        self.rootColsNode.removeChildren()
        self.rootFilterNode.removeChildren()
        super.clearRootNodes()
    }

    @objc
    required public init(fetchController fc: WOTDataFetchControllerProtocol, modelListener: WOTDataModelListener, nodeCreator nc: WOTNodeCreatorProtocol, metadatasource mds: WOTDataModelMetadatasource) {
        shouldDisplayEmptyColumns = false
        fetchController = fc
        listener = modelListener
        nodeCreator = nc
        metadatasource = mds

        super.init()

        fetchController?.setFetchListener(self)

        self.dimension.registerCalculatorClass(WOTDimensionColumnCalculator.self, forNodeClass: WOTPivotColNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionRowCalculator.self, forNodeClass: WOTPivotRowNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionFilterCalculator.self, forNodeClass: WOTPivotFilterNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataCalculator.self, forNodeClass: WOTPivotDataNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataGroupCalculator.self, forNodeClass: WOTPivotDataGroupNode.self)
    }

    public required init(enumerator enumer: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    override open func loadModel() {
        super.loadModel()

        do {
            try fetchController?.performFetch(nodeCreator: nodeCreator)
        } catch let error {
            print(String(describing: error))
        }
    }

    public func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol? {
        return (self.nodeIndex.item(indexPath: atIndexPath) as? WOTPivotNodeProtocol)
    }

    public func itemRect(atIndexPath: NSIndexPath) -> CGRect {
        guard let node = self.item(atIndexPath: atIndexPath) else {
            return .zero
        }
        // FIXME: node.relativeRect should be optimized
        guard let relativeRectValue = node.relativeRect else {
            return self.dimension.pivotRect(forNode: node)
        }

        return relativeRectValue.cgRectValue
    }

    public func itemsCount(section: Int) -> Int {
        #warning("currently not used")
        /*
         * be sure section is used
         * i.e. for case when two or more section displayed
         *
         */
        let cnt = self.nodeIndex.count
        return cnt
    }

    public func clearMetadataItems() {
        self.nodeIndex.reset()
        self.clearRootNodes()
    }

    public func add(metadataItems: [WOTNodeProtocol]) {
        let rows = metadataItems.compactMap { $0 as? WOTPivotRowNode }
        self.rootRowsNode.addChildArray(rows)

        let cols = metadataItems.compactMap { $0 as? WOTPivotColNode }
        self.rootColsNode.addChildArray(cols)

        let filters = metadataItems.compactMap { $0 as? WOTPivotFilterNode }
        self.rootFilterNode.addChildArray(filters)
    }

    fileprivate func makePivot() {
        self.clearMetadataItems()

        let items = self.metadatasource.metadataItems()
        self.add(metadataItems: items)

        let metadataIndex = self.nodeIndex.doAutoincrementIndex(forNodes: [self.rootFilterNode, self.rootColsNode, self.rootRowsNode])
        self.dimension.reload(forIndex: metadataIndex, nodeCreator: nodeCreator)
    }

    fileprivate func failPivot(_ error: Error) {
        listener?.didFinishLoadModel(error: error)
    }
}

extension WOTPivotDataModel: WOTPivotDimensionListenerProtocol {
    public func didLoad(dimension: WOTDimensionProtocol) {
        self.reindexNodes()
        self.listener?.didFinishLoadModel(error: nil)
    }
}

extension WOTPivotDataModel: WOTTreeProtocol {
    public func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol {
        let roots = self.rootNodes.filter { _ in forPredicate.evaluate(with: nil) }
        let result = roots.first ?? self.rootNode
        return result
    }
}

extension WOTPivotDataModel: WOTDataFetchControllerListenerProtocol {
    public func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error) {
        self.failPivot(withError)
    }

    public func fetchPerformed(by: WOTDataFetchControllerProtocol) {
        self.makePivot()
    }
}

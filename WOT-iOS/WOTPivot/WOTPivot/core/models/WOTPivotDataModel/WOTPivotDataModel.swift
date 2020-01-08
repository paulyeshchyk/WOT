//
//  WOTPivotTree.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTPivotDataModel: WOTDataModel, WOTPivotDataModelProtocol, WOTPivotNodeHolderProtocol, WOTPivotDimensionListenerProtocol {

    lazy public var dimension: WOTPivotDimensionProtocol = {
        let result = WOTPivotDimension(rootNodeHolder: self, fetchController: self.fetchController, enumerator: self.enumerator)
        result.listener = self
        return result
    }()

    @objc
    public var contentSize: CGSize {
        return self.dimension.contentSize
    }

    public var shouldDisplayEmptyColumns: Bool

    private var listener: WOTDataModelListener?
    private var fetchController: WOTDataFetchControllerProtocol
    fileprivate var nodeCreator: WOTNodeCreatorProtocol

    deinit {
        self.clearMetadataItems()
        self.fetchController.setFetchListener(nil)
    }

    //WOTPivotNodeHolderProtocol
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

    public func add(dataNode: WOTNodeProtocol) {
        self.rootDataNode.addChild(dataNode)
        self.listener?.modelHasNewDataItem()
    }

    override public var nodes: [WOTNodeProtocol] {
        return [self.rootFilterNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode]
    }

    override public func clearRootNodes() {
        self.rootDataNode.removeChildren(completion: { _ in })
        self.rootRowsNode.removeChildren(completion: { _ in })
        self.rootColsNode.removeChildren(completion: { _ in })
        self.rootFilterNode.removeChildren(completion: { _ in })
        super.clearRootNodes()
    }

    @objc
    required public init(fetchController fc: WOTDataFetchControllerProtocol, modelListener: WOTDataModelListener, nodeCreator nc: WOTNodeCreatorProtocol, enumerator: WOTNodeEnumeratorProtocol) {
        shouldDisplayEmptyColumns = false
        fetchController = fc
        listener = modelListener
        nodeCreator = nc

        super.init(enumerator: enumerator)

        self.fetchController.setFetchListener(self)

        self.dimension.registerCalculatorClass(WOTDimensionColumnCalculator.self, forNodeClass: WOTPivotColNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionRowCalculator.self, forNodeClass: WOTPivotRowNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionFilterCalculator.self, forNodeClass: WOTPivotFilterNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataCalculator.self, forNodeClass: WOTPivotDataNode.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataGroupCalculator.self, forNodeClass: WOTPivotDataGroupNode.self)
    }

    public required init(enumerator enumer: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    override public func loadModel() {
        super.loadModel()

        do {
            try self.fetchController.performFetch()
        } catch {
        }
    }

    public func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol? {
        guard let result = self.nodeIndex.item(indexPath: atIndexPath) as? WOTPivotNodeProtocol else {
            //            assert(false)
            return nil
        }
        return result
    }

    public func itemRect(atIndexPath: NSIndexPath) -> CGRect {
        guard let node = self.item(atIndexPath: atIndexPath) else {
            return .zero
        }
        //FIXME: node.relativeRect should be optimized
        guard let relativeRectValue = node.relativeRect else {
            return self.dimension.pivotRect(forNode: node)
        }

        return relativeRectValue.cgRectValue
    }

    public func itemsCount(section: Int) -> Int {
        /*
         * TODO: be sure section is used
         * i.e. for case when two or more section displayed
         *
         * currently not used
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

        if let items = self.listener?.metadataItems() {
            self.add(metadataItems: items)
        }

        let metadataIndex = self.nodeIndex.doAutoincrementIndex(forNodes: [self.rootFilterNode, self.rootColsNode, self.rootRowsNode])
        self.dimension.reload(forIndex: metadataIndex)
    }

    fileprivate func failPivot(_ error: Error) {
        listener?.modelDidFailLoad(error: error)
    }


    public func didLoad(dimension: WOTDimensionProtocol) {
        self.reindexNodes()
        self.listener?.modelDidLoad()
    }
}

extension WOTPivotDataModel: WOTTreeProtocol {

    public func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol {
        let roots = self.rootNodes.filter { _ in forPredicate.evaluate(with: nil) }
        if roots.count == 0 {
            let root = self.nodeCreator.createNode(name: "root")
            self.add(rootNode: root)
            return root
        } else {
            let root = roots.first
            return root!
        }
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

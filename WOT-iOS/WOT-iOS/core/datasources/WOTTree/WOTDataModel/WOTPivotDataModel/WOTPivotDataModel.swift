//
//  WOTPivotTree.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTPivotDataModel: WOTDataModel, WOTPivotDataModelProtocol, WOTPivotNodeHolderProtocol {

    @objc
    lazy var dimension: WOTPivotDimensionProtocol = {
        return WOTPivotDimension(rootNodeHolder: self, fetchController: self.fetchController)
    }()

    @objc
    var contentSize: CGSize {
        return self.dimension.contentSize
    }

    var shouldDisplayEmptyColumns: Bool

    private var listener: WOTDataModelListener
    private var fetchController: WOTDataFetchControllerProtocol

    deinit {
        self.clearMetadataItems()
        self.fetchController.setListener(nil)
    }

    //WOTPivotNodeHolderProtocol
    lazy var rootFilterNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root filters")
        self.add(rootNode: result)
        return result
    }()
    lazy var rootColsNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root cols")
        self.add(rootNode: result)
        return result
    }()
    lazy var rootRowsNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root rows")
        self.add(rootNode: result)
        return result
    }()
    lazy var rootDataNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root data")
        self.add(rootNode: result)
        return result
    }()

    override var nodes: [WOTNodeProtocol] {
        return [self.rootFilterNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode]
    }

    override func clearRootNodes() {
        self.rootDataNode.removeChildren(nil)
        self.rootRowsNode.removeChildren(nil)
        self.rootColsNode.removeChildren(nil)
        self.rootFilterNode.removeChildren(nil)
        super.clearRootNodes()
    }

    @objc
    required init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener) {
        shouldDisplayEmptyColumns = false
        fetchController = fetch
        listener = list

        super.init()

        self.fetchController.setListener(self)

        self.dimension.registerCalculatorClass(WOTDimensionColumnCalculator.self, forNodeClass: WOTPivotColNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionRowCalculator.self, forNodeClass: WOTPivotRowNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionFilterCalculator.self, forNodeClass: WOTPivotFilterNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataCalculator.self, forNodeClass: WOTPivotDataNodeSwift.self)
    }

    override func loadModel() {
        do {
            try self.fetchController.performFetch()
        } catch let error {
            fetchFailed(by: self.fetchController, withError: error)
        }
    }

    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol? {
        guard let result = self.nodeIndex.item(indexPath: atIndexPath) as? WOTPivotNodeProtocol else {
//            assert(false)
            return nil
        }
        return result
    }

    func itemRect(atIndexPath: NSIndexPath) -> CGRect {
        guard let node = self.item(atIndexPath: atIndexPath) else {
            return .zero
        }
        //FIXME: node.relativeRect should be optimized
        guard let relativeRectValue = node.relativeRect else {
            return self.dimension.pivotRect(forNode: node)
        }

        return relativeRectValue.cgRectValue
    }

    func itemsCount(section: Int) -> Int {
        /*
         * TODO: be sure section is used
         * i.e. for case when two or more section displayed
         *
         * currently not used
         */
        let cnt = self.nodeIndex.count
        return cnt
    }

    func clearMetadataItems() {
        self.nodeIndex.reset()
        self.clearRootNodes()
    }

    func add(metadataItems: [WOTNodeProtocol]) {
        let rows = metadataItems.compactMap { $0 as? WOTPivotRowNodeSwift }
        self.rootRowsNode.addChildArray(rows)

        let cols = metadataItems.compactMap { $0 as? WOTPivotColNodeSwift }
        self.rootColsNode.addChildArray(cols)

        let filters = metadataItems.compactMap { $0 as? WOTPivotFilterNodeSwift }
        self.rootFilterNode.addChildArray(filters)
    }

    private func makePivot() {

        self.clearMetadataItems()

        self.add(metadataItems: self.listener.metadataItems())

        let metadataIndex = self.nodeIndex.doAutoincrementIndex(forNodes: [self.rootFilterNode, self.rootColsNode, self.rootRowsNode])
        self.dimension.reload(forIndex: metadataIndex)
        self.reindexNodes()

        listener.modelDidLoad()
    }

    private func failPivot(_ error: Error) {
        listener.modelDidFailLoad(error: error)
    }
}

extension WOTPivotDataModel: WOTTreeProtocol {

    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol {
        let roots = self.rootNodes.filter { _ in forPredicate.evaluate(with: nil) }
        if roots.count == 0 {
            let root = self.createNode(name: "root")
            self.add(rootNode: root)
            return root
        } else {
            let root = roots.first
            return root!
        }
    }
}

extension WOTPivotDataModel: WOTDataFetchControllerListenerProtocol {
    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error) {
        self.failPivot(withError)
    }

    func fetchPerformed(by: WOTDataFetchControllerProtocol) {
        self.makePivot()
    }
}

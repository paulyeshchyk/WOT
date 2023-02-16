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

    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol

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
        if let result = self.nodeCreator?.createNode(name: "root filters") {
            self.add(rootNode: result)
            return result
        } else {
            fatalError("self.nodeCreator deallocated")
        }
    }()

    public lazy var rootColsNode: NodeProtocol = {
        if let result = self.nodeCreator?.createNode(name: "root cols") {
            self.add(rootNode: result)
            return result
        } else {
            fatalError("self.nodeCreator deallocated")
        }
    }()

    public lazy var rootRowsNode: NodeProtocol = {
        if let result = self.nodeCreator?.createNode(name: "root rows") {
            self.add(rootNode: result)
            return result
        } else {
            fatalError("self.nodeCreator deallocated")
        }
    }()

    public lazy var rootDataNode: NodeProtocol = {
        if let result = self.nodeCreator?.createNode(name: "root data") {
            self.add(rootNode: result)
            return result
        } else {
            fatalError("self.nodeCreator deallocated")
        }
    }()

    private lazy var rootNode: NodeProtocol = {
        if let result = self.nodeCreator?.createNode(name: "root") {
            self.add(rootNode: result)
            return result
        } else {
            fatalError("self.nodeCreator deallocated")
        }
    }()

    public var shouldDisplayEmptyColumns: Bool

    public weak var fetchController: NodeFetchControllerProtocol?
    public weak var nodeCreator: NodeCreatorProtocol?

    @objc
    public var appContext: Context?

    @objc
    public var contentSize: CGSize {
        return dimension.contentSize
    }

    private weak var modelListener: NodeDataModelListener?
    private weak var metadatasource: PivotMetaDatasourceProtocol?

    // MARK: Lifecycle

    @objc
    public required init(fetchController: NodeFetchControllerProtocol, modelListener: NodeDataModelListener, nodeCreator: NodeCreatorProtocol, metadatasource: PivotMetaDatasourceProtocol, nodeIndexType: NodeIndexProtocol.Type) {
        shouldDisplayEmptyColumns = false
        self.fetchController = fetchController
        self.modelListener = modelListener
        self.nodeCreator = nodeCreator
        self.metadatasource = metadatasource

        super.init(nodeIndexType: nodeIndexType)

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

    public required init(nodeIndexType _: NodeIndexProtocol.Type) {
        fatalError("init(nodeIndex:) has not been implemented")
    }

    deinit {
        clearMetadataItems()
        fetchController?.setFetchListener(nil)
    }

    // MARK: Open

    override open func clearRootNodes() {
        appContext?.logInspector?.log(.flow(name: "pivot", message: "clear root nodes"), sender: self)

        rootDataNode.removeChildren()
        rootRowsNode.removeChildren()
        rootColsNode.removeChildren()
        rootFilterNode.removeChildren()
        super.clearRootNodes()
    }

    override open func reindexNodes() {
        super.reindexNodes()
        appContext?.logInspector?.log(.flow(name: "pivot", message: "reindex nodes"), sender: self)
    }

    override open func loadModel() {
        // super.loadModel()
        guard let context = appContext else {
            assertionFailure("\(String(describing: Errors.contextNotFound))")
            return
        }

        context.logInspector?.log(.flow(name: "pivot", message: "start"), sender: self)

        do {
            guard let fetchController = fetchController else {
                throw Errors.noFetchControllerFound
            }

            try fetchController.performFetch(appContext: context)
        } catch {
            context.logInspector?.log(.error(error), sender: self)
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
        appContext?.logInspector?.log(.flow(name: "pivot", message: "clear metadata items"), sender: self)

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

        if let items = metadatasource?.metadataItems() {
            add(metadataItems: items)
        }

        let metadataIndex = nodeIndex.doAutoincrementIndex(forNodes: [rootFilterNode, rootColsNode, rootRowsNode])
        dimension.reload(forIndex: metadataIndex, nodeCreator: nodeCreator)
    }

    private func failPivot(_ error: Error) {
        modelListener?.didFinishLoadModel(error: error)
    }
}

// MARK: - %t + PivotDataModel.Errors

extension PivotDataModel {
    enum Errors: Error {
        case noFetchControllerFound
        case contextNotFound
    }
}

// MARK: - PivotDataModel + DimensionLoadListenerProtocol

extension PivotDataModel: DimensionLoadListenerProtocol {
    //
    public func didLoad(dimension _: NodeDimensionProtocol) {
        reindexNodes()
        modelListener?.didFinishLoadModel(error: nil)
        appContext?.logInspector?.log(.flow(name: "pivot", message: "finish"), sender: self)
    }
}

// MARK: - PivotDataModel + NodeFetchControllerListenerProtocol

extension PivotDataModel: NodeFetchControllerListenerProtocol {
    public func fetchFailed(by _: NodeFetchControllerProtocol?, withError: Error) {
        failPivot(withError)
    }

    public func fetchPerformed(by _: NodeFetchControllerProtocol) {
        makePivot()
    }
}

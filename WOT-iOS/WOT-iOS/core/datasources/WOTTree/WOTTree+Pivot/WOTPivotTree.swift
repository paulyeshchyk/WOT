//
//  WOTPivotTree.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
//typedef NSArray *(^PivotItemCreationBlock)(NSArray *predicates);


@objc
protocol WOTPivotTreeProtocol: NSObjectProtocol {
    var dimension: WOTDimensionProtocol { get }
    var pivotItemCreationBlock: (([NSPredicate]) -> ([WOTPivotNodeProtocol]))? { get set }
    var shouldDisplayEmptyColumns: Bool { get set };
    func itemRect(atIndexPath: NSIndexPath) -> CGRect
    func itemStickyType(atIndexPath: NSIndexPath) -> PivotStickyType
    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol?
    func itemsCount(section: Int) -> Int
    func clearMetadataItems()
    func add(metadataItems: [WOTPivotNodeProtocol])
    func makePivot()
}

@objc
class WOTPivotTreeSwift: WOTTreeSwift, WOTPivotTreeProtocol, RootNodeHolderProtocol {

    lazy var rootFilterNode: WOTPivotNodeProtocol = {
        return self.newRoot(name: "root filters")
    }()
    lazy var rootColsNode: WOTPivotNodeProtocol = {
        return self.newRoot(name: "root cols")
    }()
    lazy var rootRowsNode: WOTPivotNodeProtocol = {
        return self.newRoot(name: "root data")
    }()
    lazy var rootDataNode: WOTPivotNodeProtocol = {
        return self.newRoot(name: "root rows")
    }()

    var shouldDisplayEmptyColumns: Bool

    var metadataItems = [WOTPivotNodeProtocol]()
    @objc
    var pivotItemCreationBlock: (([NSPredicate]) -> ([WOTPivotNodeProtocol]))?

    deinit {
        self.clearMetadataItems()
    }

    override init(dataModel: WOTDataModel) {
        shouldDisplayEmptyColumns = false
        super.init(dataModel: dataModel)
        self.dimension.registerCalculatorClass(WOTDimensionColumnCalculator.self, forNodeClass: WOTPivotColNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionRowCalculator.self, forNodeClass: WOTPivotRowNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionFilterCalculator.self, forNodeClass: WOTPivotFilterNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataCalculator.self, forNodeClass: WOTPivotDataNodeSwift.self)
    }

    override func removeAllNodes() {
        self.rootDataNode.removeChildren(nil)
        self.rootRowsNode.removeChildren(nil)
        self.rootColsNode.removeChildren(nil)
        self.rootFilterNode.removeChildren(nil)
        super.removeAllNodes()
    }

    @objc
    lazy var dimension: WOTDimensionProtocol = {
        return WOTDimension(rootNodeHolder: self)
    }()

    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol? {
        guard let result = self.model.index.item(indexPath: atIndexPath) as? WOTPivotNodeProtocol else {
            assert(false)
            return nil
        }
        return result
    }

    private func rect(forNode: WOTNodeProtocol) -> CGRect {
        guard let calculator = self.dimension.calculatorClass(forNodeClass: type(of: forNode)) else {
            return .zero
        }
        let result = calculator.rectangle(forNode: forNode, dimension: self.dimension)
        forNode.relativeRect = NSValue(cgRect: result)
        return result
    }

    func itemRect(atIndexPath: NSIndexPath) -> CGRect {

        guard let node = self.item(atIndexPath: atIndexPath) else {
            return .zero
        }
        //FIXME: node.relativeRect should be optimized
        guard let relativeRectValue = node.relativeRect else {
            return self.rect(forNode: node)
        }

        return relativeRectValue.cgRectValue
    }


    func itemStickyType(atIndexPath: NSIndexPath) -> PivotStickyType {
        guard let node = self.item(atIndexPath: atIndexPath) else {
            return .float
        }
        return node.stickyType
    }


    func itemsCount(section: Int) -> Int {
        /*
         * TODO: be sure section is used
         * i.e. for case when two or more section displayed
         *
         * currently not used
         */
        let cnt = self.model.index.count
        return cnt
    }

    func clearMetadataItems() {
        self.model.index.reset()
        self.removeAllNodes()
        self.metadataItems.removeAll()
    }

    @objc
    func add(metadataItems: [WOTPivotNodeProtocol]) {
        self.metadataItems.append(contentsOf: metadataItems)
    }

    @objc
    func makePivot() {
        self.removeAllNodes()
        self.resortMetadata()

        let metatadaIndex = self.reindexMetaItems()
        self.makeData(index: metatadaIndex)
        self.model.index.reset()
        self.model.index.addNodesToIndex([self.rootFilterNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode])
    }

    private func resortMetadata() {

        self.rootDataNode.removeChildren(nil)

        self.rootRowsNode.removeChildren(nil)
        let rows = self.metadataItems.compactMap { $0 as? WOTPivotRowNodeSwift }
        self.rootRowsNode.addChildArray(rows)

        self.rootColsNode.removeChildren(nil)
        let cols = self.metadataItems.compactMap { $0 as? WOTPivotColNodeSwift }
        self.rootColsNode.addChildArray(cols)

        self.rootFilterNode.removeChildren(nil)
        let filters = self.metadataItems.compactMap { $0 as? WOTPivotFilterNodeSwift }
        self.rootFilterNode.addChildArray(filters)
    }

    private func makeData(index externalIndex: Int) {

        guard let block = self.pivotItemCreationBlock else {
            return
        }

        var index = externalIndex
        let colNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootColsNode)
        let rowNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootRowsNode)
        rowNodeEndpoints.forEach { (rowNode) in

            if (rowNode as? WOTPivotNodeProtocol)?.predicate != nil {

                colNodeEndpoints.forEach({ (colNode) in
                    let predicates = self.predicates(colNode: colNode, rowNode: rowNode)
                    let dataNodes = block(predicates)
                    self.dimension.setMaxWidth(dataNodes.count, forNode: colNode, byKey: rowNode.hashString)
                    self.dimension.setMaxWidth(dataNodes.count, forNode: rowNode, byKey: colNode.hashString)
                    var idx: Int = 0
                    dataNodes.forEach({ (dataNode) in
                        dataNode.index = index
                        index += 1
                        dataNode.stepParentColumn = colNode
                        dataNode.stepParentRow = rowNode
                        dataNode.indexInsideStepParentColumn = idx
                        self.rootDataNode.addChild(dataNode)
                        idx += 1
                    })
                })
            }
        }
    }

    private func predicates(colNode: WOTNodeProtocol, rowNode: WOTNodeProtocol) -> [NSPredicate] {
        var result = [NSPredicate]()
        if let colPredicate = (colNode as? WOTPivotNodeProtocol)?.predicate {
            result.append(colPredicate)
        }
        if let rowPredicate = (rowNode as? WOTPivotNodeProtocol)?.predicate {
            result.append(rowPredicate)
        }

        let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootFilterNode)
        endpoints.forEach { (fnode) in
            if let filterPredicate = (fnode as? WOTPivotNodeProtocol)?.predicate {
                result.append(filterPredicate)
            }
        }
        return result

    }


    private func reindexMetaItems() -> Int {
        var result: Int = 0
        WOTNodeEnumerator.sharedInstance.enumerateAll(node: self.rootFilterNode, comparator: { (_, _, _) -> ComparisonResult in
            return ComparisonResult.orderedSame

        }) { (node) in
            node.index = result
            result += 1
        }

        WOTNodeEnumerator.sharedInstance.enumerateAll(node: self.rootColsNode, comparator: { (obj1, obj2, level) -> ComparisonResult in
            return obj1.name.compare(obj2.name)
        }) { (node) in

            node.index = result
            result += 1
        }

        WOTNodeEnumerator.sharedInstance.enumerateAll(node: self.rootRowsNode, comparator: { (obj1, obj2, level) -> ComparisonResult in
            if let predicate1 = (obj1 as? WOTPivotNodeProtocol)?.predicate, let predicate2 = (obj2 as? WOTPivotNodeProtocol)?.predicate {
                return predicate1.predicateFormat.compare(predicate2.predicateFormat)
            } else {
                return ComparisonResult.orderedAscending
            }

        }) { (node) in
            node.index = result
            result += 1
        }

        return result
    }

    private func newRoot(name: String) -> WOTPivotNodeProtocol {
        let result = WOTPivotNodeSwift(name: name)
        result.isVisible = false
        self.addNode(node: result)
        return result
    }
}

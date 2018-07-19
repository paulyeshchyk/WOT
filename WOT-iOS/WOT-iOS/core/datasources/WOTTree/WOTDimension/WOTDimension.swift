//
//  WOTDimension.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/13/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
typealias TNodeSize = [String: Int]
typealias TNodesSizesType = [AnyHashable: TNodeSize]

@objc
protocol RootNodeHolderProtocol: NSObjectProtocol {
    var rootFilterNode: WOTNodeProtocol { get }
    var rootColsNode: WOTNodeProtocol { get }
    var rootRowsNode: WOTNodeProtocol { get }
    var rootDataNode: WOTNodeProtocol { get }
    func resortMetadata(metadataItems: [WOTNodeProtocol])
    func reindexMetaItems() -> Int
}

@objc
class WOTDimension: NSObject, WOTDimensionProtocol {

    private func hashValue(type: Any.Type) -> Int {
        return ObjectIdentifier(type).hashValue
    }

    private var fetchController: WOTDataFetchControllerProtocol
    private var registeredCalculators = [AnyHashable: AnyClass]()

    func registerCalculatorClass( _ calculatorClass: WOTDimensionCalculator.Type, forNodeClass: AnyClass) {
        let hash = hashValue(type: forNodeClass)
        self.registeredCalculators[hash] = calculatorClass
    }

    func calculatorClass(forNodeClass: AnyClass) -> WOTDimensionCalculator.Type? {
        let hash = hashValue(type: forNodeClass)
        let result: WOTDimensionCalculator.Type? = self.registeredCalculators[hash] as? WOTDimensionCalculator.Type
        return result
    }

    private var sizes: TNodesSizesType = TNodesSizesType()

    private func sizeMap(node: WOTNodeProtocol) -> TNodeSize? {
        if let obj = node as? AnyHashable {
            return sizes[obj]
        }
        return nil
    }

    private func set(sizeMap: TNodeSize, node: WOTNodeProtocol) {
        if let obj = node as? AnyHashable {
            sizes[obj] = sizeMap
        }
    }

    func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String) {
        guard maxWidth != 0 else {
            return
        }

        var nodeSizes = TNodeSize()

        if let oldSizes = sizeMap(node: forNode) {
            oldSizes.keys.forEach { (key) in
                nodeSizes[key] = oldSizes[key]
            }
        }

        var value = 0
        if let nodeSizesValue = nodeSizes[byKey] {
            value = nodeSizesValue
        }

        let maxValue = max(value, maxWidth)
        nodeSizes[byKey] = maxValue
        set(sizeMap: nodeSizes, node: forNode)

    }

    func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int {
        var result = orValue

        guard let nodeSizes = sizeMap(node: node) else {
            return result
        }
        nodeSizes.keys.forEach { (key) in
            if let oldValue = nodeSizes[key] {
                result = max(oldValue, result)
            }
        }
        return result
    }

    func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int {
        var result: Int = 0
        guard let parent = node.parent else {
            return result
        }
        guard let indexOfNode = ( parent.children.index { $0 === node}) else {
            return result
        }

        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: child)
            endpoints.forEach { (endpoint) in
                result += self.maxWidth(endpoint, orValue: orValue)
            }

        }
        result += self.childrenMaxWidth(parent, orValue: orValue)
        return result
    }

    private var rootNodeHolder: RootNodeHolderProtocol

    required init(rootNodeHolder: RootNodeHolderProtocol, fetchController: WOTDataFetchControllerProtocol) {
        self.fetchController = fetchController
        self.rootNodeHolder = rootNodeHolder
    }

    var shouldDisplayEmptyColumns: Bool {
        return false
    }

    var rootNodeWidth: Int {
        let rows = self.rootNodeHolder.rootRowsNode
        let level = rows.isVisible ? 1 : 0
        return WOTNodeEnumerator.sharedInstance.depth(forChildren: rows.children, initialLevel: level)
    }

    var rootNodeHeight: Int {
        let cols = self.rootNodeHolder.rootColsNode
        let level = cols.isVisible ? 1 : 0
        return WOTNodeEnumerator.sharedInstance.depth(forChildren: cols.children, initialLevel: level)
    }

    var contentSize: CGSize {
        let rowNodesDepth = self.rootNodeWidth
        let colNodesDepth = self.rootNodeHeight
        let emptyDayaColumnWidth = self.shouldDisplayEmptyColumns ? 1 : 0
        let rootCols = self.rootNodeHolder.rootColsNode
        let columnEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: rootCols)
        var maxWidth: Int = 0
        columnEndpoints.forEach { (column) in
            let value = self.maxWidth(column, orValue: emptyDayaColumnWidth)
            maxWidth += value
        }

        let rootRows = self.rootNodeHolder.rootRowsNode
        let width = rowNodesDepth + maxWidth
        let rowEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: rootRows)
        let rowNodesEndpointsCount = rowEndpoints.count
        let height = colNodesDepth + rowNodesEndpointsCount
        return CGSize(width: width, height: height)//156:11
    }

    func fetchData(index externalIndex: Int) {
        var index = externalIndex
        let colNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootColsNode)
        let rowNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootRowsNode)
        rowNodeEndpoints.forEach { (rowNode) in
            colNodeEndpoints.forEach({ (colNode) in
                let predicates = self.predicates(colNode: colNode, rowNode: rowNode)
                let fetchedNodes = self.fetchController.fetchedNodes(byPredicates: predicates)
                self.setMaxWidth(fetchedNodes.count, forNode: colNode, byKey: rowNode.hashString)
                self.setMaxWidth(fetchedNodes.count, forNode: rowNode, byKey: colNode.hashString)
                var idx: Int = 0
                fetchedNodes.forEach({ (fetchedNode) in
                    fetchedNode.index = index
                    index += 1
                    fetchedNode.stepParentColumn = colNode
                    fetchedNode.stepParentRow = rowNode
                    fetchedNode.indexInsideStepParentColumn = idx
                    self.rootNodeHolder.rootDataNode.addChild(fetchedNode)
                    idx += 1
                })
            })
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

        let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootFilterNode)
        endpoints.forEach { (fnode) in
            if let filterPredicate = (fnode as? WOTPivotNodeProtocol)?.predicate {
                result.append(filterPredicate)
            }
        }
        return result
    }
}

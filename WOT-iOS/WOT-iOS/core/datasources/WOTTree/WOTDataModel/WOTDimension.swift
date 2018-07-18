//
//  WOTDimension.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/13/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol RootNodeHolderProtocol: NSObjectProtocol {
    var rootFilterNode: WOTNodeProtocol { get }
    var rootColsNode: WOTNodeProtocol { get }
    var rootRowsNode: WOTNodeProtocol { get }
    var rootDataNode: WOTNodeProtocol { get }
    func resortMetadata(metadataItems: [WOTNodeProtocol])
    func reindexMetaItems() -> Int
}
typealias PivotItemCreationType = ([NSPredicate]) -> ([WOTNodeProtocol])

/**

 ***********************************************************************
 *              *         1           *         2         *      3     *
 *              ********************************************************
 *              *    1    *     2     *    3    *    4    *      5     *
 ***********************************************************************
 *     *   1    *
 *  1  **********
 *     *   2    *
 ****************
 *     *   3    *
 *     **********
 *     *   4    *
 *  2  **********
 *     *   5    *
 *     **********
 *     *   6    *
 ****************
 */

@objc
protocol WOTDimensionProtocol: NSObjectProtocol {
    init(rootNodeHolder: RootNodeHolderProtocol, pivotCreation: @escaping PivotItemCreationType)
    var shouldDisplayEmptyColumns: Bool { get }
    /**
     *  for table above returns 5
     */
    var rootNodeWidth: Int { get }
    /**
     *  for table above returns 6
     */
    var rootNodeHeight: Int { get }
    /**
     *  for table above returns {7,8}
     *  {rowsDepth+colsEndpoints, colsDepth+rowsEndpoints}
     */
    var contentSize: CGSize { get }
    func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String)
    func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int
    func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int

    func registerCalculatorClass( _ calculatorClass: WOTDimensionCalculator.Type, forNodeClass: AnyClass)
    func calculatorClass(forNodeClass: AnyClass) -> WOTDimensionCalculator.Type?

    func makeData(index: Int)
    var pivotItemCreationBlock: PivotItemCreationType { get set }

}

typealias TNodeSize = [String: Int]
typealias TNodesSizesType = [AnyHashable: TNodeSize]


@objc
class WOTDimension: NSObject, WOTDimensionProtocol {

    private func hashValue(type: Any.Type) -> Int {
        return ObjectIdentifier(type).hashValue
    }

    private var registeredCalculators:Dictionary<AnyHashable, AnyClass> = Dictionary<AnyHashable, AnyClass>()

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
            if let oldValue = nodeSizes[key]{
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
        guard let indexOfNode = ( parent.children.index { $0 === node} ) else {
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

    required init(rootNodeHolder: RootNodeHolderProtocol, pivotCreation: @escaping PivotItemCreationType) {
        self.pivotItemCreationBlock = pivotCreation
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
        return CGSize(width: width, height: height)
    }

    func makeData(index externalIndex: Int) {
        var index = externalIndex
        let colNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootColsNode)
        let rowNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootRowsNode)
        rowNodeEndpoints.forEach { (rowNode) in
            colNodeEndpoints.forEach({ (colNode) in
                let predicates = self.predicates(colNode: colNode, rowNode: rowNode)
                let dataNodes = self.pivotItemCreationBlock(predicates)
                self.setMaxWidth(dataNodes.count, forNode: colNode, byKey: rowNode.hashString)
                self.setMaxWidth(dataNodes.count, forNode: rowNode, byKey: colNode.hashString)
                var idx: Int = 0
                dataNodes.forEach({ (dataNode) in
                    dataNode.index = index
                    index += 1
                    dataNode.stepParentColumn = colNode
                    dataNode.stepParentRow = rowNode
                    dataNode.indexInsideStepParentColumn = idx
                    self.rootNodeHolder.rootDataNode.addChild(dataNode)
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

    var pivotItemCreationBlock: PivotItemCreationType




}

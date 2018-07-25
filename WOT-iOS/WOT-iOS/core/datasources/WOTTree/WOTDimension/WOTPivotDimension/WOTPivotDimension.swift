//
//  WOTPivotDimension.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/20/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTPivotDimension: WOTDimension, WOTPivotDimensionProtocol {

    private var rootNodeHolder: WOTPivotNodeHolderProtocol
    required init(rootNodeHolder: WOTPivotNodeHolderProtocol, fetchController: WOTDataFetchControllerProtocol) {
        self.rootNodeHolder = rootNodeHolder
        super.init(fetchController: fetchController)
    }

    required init(fetchController: WOTDataFetchControllerProtocol) {
        fatalError("init(fetchController:) has not been implemented")
    }

    private var registeredCalculators = [AnyHashable: AnyClass]()
    func registerCalculatorClass(_ calculatorClass: WOTDimensionCalculator.Type, forNodeClass: AnyClass) {
        let hash = hashValue(type: forNodeClass)
        self.registeredCalculators[hash] = calculatorClass
    }

    func calculatorClass(forNodeClass: AnyClass) -> WOTDimensionCalculator.Type? {
        let hash = hashValue(type: forNodeClass)
        let result: WOTDimensionCalculator.Type? = self.registeredCalculators[hash] as? WOTDimensionCalculator.Type
        return result
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

    override var contentSize: CGSize {
        let height = self.getHeight()
        let width = self.getWidth()
        return CGSize(width: width, height: height)//156:11
    }

    override func reload(forIndex externalIndex: Int) {
        var index = externalIndex
        let colNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootColsNode)
        let rowNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootRowsNode)
        let filterEndPoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootFilterNode)
        rowNodeEndpoints.forEach { (rowNode) in
            colNodeEndpoints.forEach({ (colNode) in
                filterEndPoints.forEach({ (filterNode) in
                    index = updateDimensions(externalIndex: index, colNode: colNode, rowNode: rowNode, filterNode: filterNode)
                })
            })
        }
    }

    private func fetchDataNodes(colNode: WOTNodeProtocol, rowNode: WOTNodeProtocol, filterNode: WOTNodeProtocol) -> [WOTNodeProtocol] {
        let predicates = self.predicates(colNode: colNode, rowNode: rowNode, filterNode: filterNode)
        let fetchedNodes = self.fetchController.fetchedNodes(byPredicates: predicates)
        self.setMaxWidth(fetchedNodes.count, forNode: colNode, byKey: String(format: "%d", rowNode.hash))
        self.setMaxWidth(fetchedNodes.count, forNode: rowNode, byKey: String(format: "%d", colNode.hash))
        return fetchedNodes
    }

    private func updateDimensions(externalIndex: Int, colNode: WOTNodeProtocol, rowNode: WOTNodeProtocol, filterNode: WOTNodeProtocol) -> Int {
        var result = externalIndex

        let fetchedNodes = fetchDataNodes(colNode: colNode, rowNode: rowNode, filterNode: filterNode)

        var idx: Int = 0
        fetchedNodes.forEach({ (fetchedNode) in
            guard let pivotNode = fetchedNode as? WOTPivotNodeProtocol else {
                return
            }
            pivotNode.index = result
            result += 1
            pivotNode.stepParentColumn = colNode
            pivotNode.stepParentRow = rowNode
            pivotNode.indexInsideStepParentColumn = idx
            self.rootNodeHolder.rootDataNode.addChild(pivotNode)
            idx += 1
        })
        return result
    }

    private func predicates(colNode: WOTNodeProtocol, rowNode: WOTNodeProtocol, filterNode: WOTNodeProtocol) -> [NSPredicate] {
        var result = [NSPredicate]()
        if let colPredicate = (colNode as? WOTPivotNodeProtocol)?.predicate {
            result.append(colPredicate)
        }
        if let rowPredicate = (rowNode as? WOTPivotNodeProtocol)?.predicate {
            result.append(rowPredicate)
        }
        if let filterPredicate = (filterNode as? WOTPivotNodeProtocol)?.predicate {
            result.append(filterPredicate)
        }
        return result
    }

    private func getWidth() -> Int {
        let rootCols = self.rootNodeHolder.rootColsNode
        let columnEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: rootCols)
        let emptyDayaColumnWidth = self.shouldDisplayEmptyColumns ? 1 : 0

        var maxWidth: Int = 0
        columnEndpoints.forEach { (column) in
            let value = self.maxWidth(column, orValue: emptyDayaColumnWidth)
            maxWidth += value
        }
        return self.rootNodeWidth + maxWidth
    }

    private func getHeight() -> Int {
        let rootRows = self.rootNodeHolder.rootRowsNode
        let rowNodesEndpointsCount = WOTNodeEnumerator.sharedInstance.endpoints(node: rootRows).count
        return self.rootNodeHeight + rowNodesEndpointsCount
    }

    private func hashValue(type: Any.Type) -> Int {
        return ObjectIdentifier(type).hashValue
    }

    func pivotRect(forNode: WOTPivotNodeProtocol) -> CGRect {
        guard let calculator = self.calculatorClass(forNodeClass: type(of: forNode)) else {
            return .zero
        }
        let result = calculator.rectangle(forNode: forNode, dimension: self)
        forNode.relativeRect = NSValue(cgRect: result)
        return result
    }
}

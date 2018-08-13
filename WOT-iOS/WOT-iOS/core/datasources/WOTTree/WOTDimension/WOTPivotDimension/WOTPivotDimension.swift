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

    private var index: Int = 0

    override func reload(forIndex externalIndex: Int, completion:  ()->()) {

        self.index = externalIndex
        let colNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootColsNode)
        let rowNodeEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootRowsNode)
        let filterEndPoints = WOTNodeEnumerator.sharedInstance.endpoints(node: self.rootNodeHolder.rootFilterNode)
        rowNodeEndpoints.forEach { (rowNode) in
            colNodeEndpoints.forEach({ (colNode) in
                filterEndPoints.forEach({ (filterNode) in
                    self.updateDimensions(colNode: colNode, rowNode: rowNode, filterNode: filterNode)
                })
            })
        }
        completion()
    }

    private func updateDimensions(colNode: WOTNodeProtocol, rowNode: WOTNodeProtocol, filterNode: WOTNodeProtocol) {
        var result = self.index

        let predicates = [colNode, rowNode, filterNode].compactMap { ($0 as? WOTPivotNodeProtocol)?.fullPredicate }
        let dataNodes = self.fetchController.fetchedNodes(byPredicates: predicates)

        self.setMaxWidth(dataNodes.count, forNode: colNode, byKey: String(format: "%d", rowNode.hash))
        self.setMaxWidth(dataNodes.count, forNode: rowNode, byKey: String(format: "%d", colNode.hash))

        var idx: Int = 0
        dataNodes.forEach({ (fetchedNode) in
            guard let dataNode = fetchedNode as? WOTPivotNodeProtocol else {
                return
            }
            dataNode.index = result
            result += 1
            dataNode.stepParentColumn = colNode
            dataNode.stepParentRow = rowNode
            dataNode.indexInsideStepParentColumn = idx
            self.rootNodeHolder.add(dataNode: dataNode)
            idx += 1
        })
        self.index = result
    }

    private func getWidth() -> Int {
        let rootCols = self.rootNodeHolder.rootColsNode
        let columnEndpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: rootCols)
        let emptyDataColumnWidth = self.shouldDisplayEmptyColumns ? 1 : 0

        var maxWidth: Int = 0
        columnEndpoints.forEach { (column) in
            let value = self.maxWidth(column, orValue: emptyDataColumnWidth)
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

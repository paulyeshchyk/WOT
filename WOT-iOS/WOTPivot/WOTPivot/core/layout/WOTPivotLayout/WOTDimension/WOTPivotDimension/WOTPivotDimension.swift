//
//  WOTPivotDimension.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public class WOTPivotDimension: WOTDimension, WOTPivotDimensionProtocol {

    public var listener: WOTPivotDimensionListenerProtocol?

    private var rootNodeHolder: WOTPivotNodeHolderProtocol
    required public init(rootNodeHolder: WOTPivotNodeHolderProtocol, fetchController: WOTDataFetchControllerProtocol, enumerator: WOTNodeEnumeratorProtocol) {
        self.rootNodeHolder = rootNodeHolder
        super.init(fetchController: fetchController, enumerator: enumerator)
    }

    required public init(fetchController: WOTDataFetchControllerProtocol) {
        fatalError("init(fetchController:) has not been implemented")
    }

    required public init(fetchController: WOTDataFetchControllerProtocol, enumerator: WOTNodeEnumeratorProtocol) {
        fatalError("init(fetchController:enumerator:) has not been implemented")
    }

    private var registeredCalculators = [AnyHashable: AnyClass]()
    public func registerCalculatorClass(_ calculatorClass: WOTDimensionCalculator.Type, forNodeClass: AnyClass) {
        let hash = hashValue(type: forNodeClass)
        self.registeredCalculators[hash] = calculatorClass
    }

    public func calculatorClass(forNodeClass: AnyClass) -> WOTDimensionCalculator.Type? {
        let hash = hashValue(type: forNodeClass)
        let result: WOTDimensionCalculator.Type? = self.registeredCalculators[hash] as? WOTDimensionCalculator.Type
        return result
    }

    public var rootNodeWidth: Int {
        let rows = self.rootNodeHolder.rootRowsNode
        let level = rows.isVisible ? 1 : 0
        return self.enumerator.depth(forChildren: rows.children, initialLevel: level)
    }

    public var rootNodeHeight: Int {
        let cols = self.rootNodeHolder.rootColsNode
        let level = cols.isVisible ? 1 : 0
        return self.enumerator.depth(forChildren: cols.children, initialLevel: level)
    }

    override public var contentSize: CGSize {
        let height = self.getHeight()
        let width = self.getWidth()
        return CGSize(width: width, height: height)//156:11
    }

    private var index: Int = 0

    //TODO: !!! TO BE refactored: too slow !!!
    override public func reload(forIndex externalIndex: Int) {
        self.index = externalIndex
        let colNodeEndpoints = self.enumerator.endpoints(node: self.rootNodeHolder.rootColsNode)
        let rowNodeEndpoints = self.enumerator.endpoints(node: self.rootNodeHolder.rootRowsNode)
        let filterEndPoints = self.enumerator.endpoints(node: self.rootNodeHolder.rootFilterNode)
        var counter = colNodeEndpoints.count * rowNodeEndpoints.count * filterEndPoints.count

        rowNodeEndpoints.forEach { (rowNode) in
            colNodeEndpoints.forEach({ (colNode) in
                filterEndPoints.forEach({(filterNode) in
                    DispatchQueue.main.async {


                        //TODO: should we use predicate instead of fullPredicate ?
                        let colFullPredicate = (colNode as? WOTPivotNodeProtocol)?.predicate
                        let rowFullPredicate = (rowNode as? WOTPivotNodeProtocol)?.predicate
                        let filterFullPredicate = (filterNode as? WOTPivotNodeProtocol)?.predicate

                        let predicates = [colFullPredicate, rowFullPredicate, filterFullPredicate].compactMap { $0 }
                        let dataNodes = self.fetchController.fetchedNodes(byPredicates: predicates)
                        self.updateDimensions(dataNodes: dataNodes, colNode: colNode, rowNode: rowNode, filterNode: filterNode)
                        counter -= 1
                        if (counter == 0) {
                            self.listener?.didLoad(dimension: self)
                        }
                    }
                })
            })
        }

    }

    private func updateDimensions(dataNodes: [WOTNodeProtocol], colNode: WOTNodeProtocol, rowNode: WOTNodeProtocol, filterNode: WOTNodeProtocol) {

        var result = self.index

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
        let columnEndpoints = self.enumerator.endpoints(node: rootCols)
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
        let rowNodesEndpointsCount = self.enumerator.endpoints(node: rootRows).count
        return self.rootNodeHeight + rowNodesEndpointsCount
    }

    private func hashValue(type: Any.Type) -> Int {
        return ObjectIdentifier(type).hashValue
    }

    public func pivotRect(forNode: WOTPivotNodeProtocol) -> CGRect {
        guard let calculator = self.calculatorClass(forNodeClass: type(of: forNode)) else {
            return .zero
        }
        let result = calculator.rectangle(forNode: forNode, dimension: self)
        forNode.relativeRect = NSValue(cgRect: result)
        return result
    }
}

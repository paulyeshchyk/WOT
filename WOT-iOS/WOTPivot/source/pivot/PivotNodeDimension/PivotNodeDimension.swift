//
//  PivotNodeDimension.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public class PivotNodeDimension: NodeDimension, PivotNodeDimensionProtocol {

    public weak var listener: DimensionLoadListenerProtocol?

    public var rootNodeWidth: Int {
        let rows = rootNodeHolder.rootRowsNode
        let level = rows.isVisible ? 1 : 0
        return enumerator?.depth(forChildren: rows.children, initialLevel: level) ?? 0
    }

    public var rootNodeHeight: Int {
        let cols = rootNodeHolder.rootColsNode
        let level = cols.isVisible ? 1 : 0
        return enumerator?.depth(forChildren: cols.children, initialLevel: level) ?? 0
    }

    override public var contentSize: CGSize {
        let height = getHeight()
        let width = getWidth()
        return CGSize(width: width, height: height) // 156:11
    }

    private unowned var rootNodeHolder: PivotNodeDatasourceProtocol
    private var registeredCalculators = [AnyHashable: AnyClass]()
    private var index: NodeIndexType = 0

    #warning(" !!! TO BE refactored: too slow !!! ")

    // MARK: Lifecycle

    public required init(rootNodeHolder: PivotNodeDatasourceProtocol) {
        self.rootNodeHolder = rootNodeHolder
        super.init()
    }

    public required init(enumerator _: NodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    // MARK: Public

    public func registerCalculatorClass(_ calculatorClass: PivotDimensionCalculator.Type, forNodeClass: AnyClass) {
        let hash = hashValue(type: forNodeClass)
        registeredCalculators[hash] = calculatorClass
    }

    public func calculatorClass(forNodeClass: AnyClass) -> PivotDimensionCalculator.Type? {
        let hash = hashValue(type: forNodeClass)
        let result: PivotDimensionCalculator.Type? = registeredCalculators[hash] as? PivotDimensionCalculator.Type
        return result
    }

    override public func reload(forIndex externalIndex: Int, nodeCreator: NodeCreatorProtocol?) {
        index = externalIndex

        let colNodeEndpoints = enumerator?.endpoints(node: rootNodeHolder.rootColsNode)
        let rowNodeEndpoints = enumerator?.endpoints(node: rootNodeHolder.rootRowsNode)
        let filterEndPoints = enumerator?.endpoints(node: rootNodeHolder.rootFilterNode)

        let dispatchGroup = DispatchGroup()
        colNodeEndpoints?.forEach { (colNode) in
            rowNodeEndpoints?.forEach { (rowNode) in
                filterEndPoints?.forEach { (filterNode) in

                    dispatchGroup.enter()
                    #warning("should we use predicate instead of fullPredicate ?")
                    let colFullPredicate = (colNode as? PivotNodeProtocol)?.predicate
                    let rowFullPredicate = (rowNode as? PivotNodeProtocol)?.predicate
                    let filterFullPredicate = (filterNode as? PivotNodeProtocol)?.predicate

                    let predicates = [colFullPredicate, rowFullPredicate, filterFullPredicate].compactMap { $0 }
                    fetchController?.fetchedNodes(byPredicates: predicates, nodeCreator: nodeCreator) { predicate, filtered in
                        var dataNodes = [NodeProtocol]()
                        let compacted = filtered?.compactMap { $0 } ?? []
                        if let nodes = nodeCreator?.createNodes(fetchedObjects: compacted, byPredicate: predicate) {
                            dataNodes.append(contentsOf: nodes)
                        }
                        self.updateDimensions(dataNodes: dataNodes, colNode: colNode, rowNode: rowNode, filterNode: filterNode)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.listener?.didLoad(dimension: self)
        }
    }

    public func pivotRect(forNode: PivotNodeProtocol) -> CGRect {
        guard let calculator = calculatorClass(forNodeClass: type(of: forNode)) else {
            return .zero
        }
        let result = calculator.rectangle(forNode: forNode, dimension: self)
        forNode.relativeRect = NSValue(cgRect: result)
        return result
    }

    // MARK: Private

    private func updateDimensions(dataNodes: [NodeProtocol], colNode: NodeProtocol, rowNode: NodeProtocol, filterNode _: NodeProtocol) {
        var result = index

        setMaxWidth(dataNodes.count, forNode: colNode, byKey: String(format: "%d", rowNode.hash))
        setMaxWidth(dataNodes.count, forNode: rowNode, byKey: String(format: "%d", colNode.hash))

        var idx: Int = 0
        dataNodes.forEach { (fetchedNode) in
            guard let dataNode = fetchedNode as? PivotNodeProtocol else {
                return
            }
            dataNode.index = result
            result += 1
            dataNode.stepParentColumn = colNode
            dataNode.stepParentRow = rowNode
            dataNode.indexInsideStepParentColumn = idx
            self.rootNodeHolder.add(dataNode: dataNode)
            idx += 1
        }
        index = result
    }

    private func getWidth() -> Int {
        let rootCols = rootNodeHolder.rootColsNode
        let columnEndpoints = enumerator?.endpoints(node: rootCols)
        let emptyDataColumnWidth = shouldDisplayEmptyColumns ? 1 : 0

        var maxWidth: Int = 0
        columnEndpoints?.forEach { (column) in
            let value = self.maxWidth(column, orValue: emptyDataColumnWidth)
            maxWidth += value
        }
        return rootNodeWidth + maxWidth
    }

    private func getHeight() -> Int {
        let rootRows = rootNodeHolder.rootRowsNode
        let rowNodesEndpointsCount = enumerator?.endpoints(node: rootRows)?.count ?? 0
        return rootNodeHeight + rowNodesEndpointsCount
    }

    private func hashValue(type: Any.Type) -> Int {
        return ObjectIdentifier(type).hashValue
    }
}

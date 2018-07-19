//
//  WOTPivotTree.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation


protocol WOTTreeProtocol: NSObjectProtocol {
    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol
}

@objc
protocol WOTPivotTreeProtocol: NSObjectProtocol {
    var dimension: WOTDimensionProtocol { get }
    var shouldDisplayEmptyColumns: Bool { get set };
    func itemRect(atIndexPath: NSIndexPath) -> CGRect
    func itemStickyType(atIndexPath: NSIndexPath) -> PivotStickyType
    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol?
    func itemsCount(section: Int) -> Int
    func clearMetadataItems()
    func add(metadataItems: [WOTNodeProtocol])
    func makePivot()
}

@objc
protocol WOTDataFetchControllerProtocol {
    func fetchedNodes(byPredicates:[NSPredicate]) -> [WOTPivotNodeProtocol]
}

@objc
class WOTPivotDataModel: WOTDataModel, WOTPivotTreeProtocol, WOTTreeProtocol {

    @objc
    lazy var dimension: WOTDimensionProtocol = {
        return WOTDimension(rootNodeHolder: self, fetchController: self.fetchController)
    }()

    var shouldDisplayEmptyColumns: Bool

    var metadataItems = [WOTNodeProtocol]()

    @objc
    var fetchController: WOTDataFetchControllerProtocol

    deinit {
        self.clearMetadataItems()
    }

    @objc
    required init(fetchController fetch: WOTDataFetchControllerProtocol ) {
        shouldDisplayEmptyColumns = true
        fetchController = fetch

        super.init()

        self.dimension.registerCalculatorClass(WOTDimensionColumnCalculator.self, forNodeClass: WOTPivotColNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionRowCalculator.self, forNodeClass: WOTPivotRowNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionFilterCalculator.self, forNodeClass: WOTPivotFilterNodeSwift.self)
        self.dimension.registerCalculatorClass(WOTDimensionDataCalculator.self, forNodeClass: WOTPivotDataNodeSwift.self)
    }

    func item(atIndexPath: NSIndexPath) -> WOTPivotNodeProtocol? {
        guard let result = self.nodeIndex.item(indexPath: atIndexPath) as? WOTPivotNodeProtocol else {
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
        let cnt = self.nodeIndex.count
        return cnt
    }

    func clearMetadataItems() {
        self.nodeIndex.reset()
        self.removeAll()
        self.metadataItems.removeAll()
    }

    @objc
    func add(metadataItems: [WOTNodeProtocol]) {
        self.metadataItems.append(contentsOf: metadataItems)
    }

    @objc
    func makePivot() {
        self.removeAll()
        self.resortMetadata(metadataItems: self.metadataItems)
        let metadataIndex = self.reindexMetaItems()
        self.dimension.fetchData(index: metadataIndex)
        self.resetNodeIndex()
    }

    // WOTTreeProtocol
    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol {
        let roots = self.rootNodes.filter { _ in forPredicate.evaluate(with: nil) }
        if roots.count == 0 {
            let root = self.createNode(name: "root")
            self.add(node: root)
            return root
        } else {
            let root = roots.first
            return root!
        }
    }
}

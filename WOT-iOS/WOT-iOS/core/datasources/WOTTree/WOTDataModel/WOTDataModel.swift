//
//  WOTDataModel.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/11/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTNodeComparator = (_ left: WOTNodeProtocol, _ right: WOTNodeProtocol) -> Bool
typealias WOTIndexTypeAlias = Dictionary<Int, [WOTNodeProtocol]>

@objc
public protocol WOTNodeCreatorProtocol {
    func createNode(name: String) -> WOTNodeProtocol
}

@objc
public protocol WOTDataModelProtocol {
    var index: WOTNodeIndexProtocol { get }
    var rootNodes: [WOTNodeProtocol] { get }
    var levels: Int { get }
    var width: Int { get }
    var endpointsCount: Int { get }
    func add(node: WOTNodeProtocol)
    func remove(node: WOTNodeProtocol)
    func removeAll()
    func allObjects(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol]
    func nodesCount(section: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> WOTNodeProtocol?
}

@objc
public class WOTDataModel: NSObject, WOTDataModelProtocol, RootNodeHolderProtocol {

    lazy public var index: WOTNodeIndexProtocol = {
        return WOTNodeIndex()
    }()
    
    private(set)public var rootNodes: [WOTNodeProtocol]
    private var comparator: WOTNodeComparator = { (left, right) in
        return true
    }

    private lazy var levelIndex: WOTIndexTypeAlias = {
        return WOTIndexTypeAlias()
    }()

    public var levels: Int {
        return self.levelIndex.keys.count
    }

    public var width: Int {
        var result: Int = 0
        self.levelIndex.keys.forEach { (key) in
            let arraycount = self.levelIndex[key]?.count ?? 0
            result = max(result, arraycount)
        }
        return result
    }

    public var endpointsCount: Int {
        return WOTNodeEnumerator.sharedInstance.endpoints(array: self.rootNodes).count
    }

    override init() {
        self.rootNodes = []
    }

    private func reindex() {
        self.levelIndex.removeAll()
        let level: Int = 0
        let rootNodes = self.allObjects(sortComparator: nil)
        rootNodes.forEach { (node) in
            self.reindexChildNode(node, atLevel: level)
        }
    }

    private func reindexChildNode(_ node: WOTNodeProtocol, atLevel: Int) {
        var itemsAtLevel = self.levelIndex[atLevel] ?? [WOTNodeProtocol]()
        itemsAtLevel.append(node)
        self.levelIndex[atLevel] = itemsAtLevel

        node.children.forEach { (child) in
            self.reindexChildNode(child, atLevel: atLevel + 1)
        }
    }

    public func add(node: WOTNodeProtocol) {
        self.rootNodes.append(node)
        reindex()
    }

    public func remove(node: WOTNodeProtocol) {
        guard let index = (self.rootNodes.index { $0 === node}) else {
            return
        }
        self.rootNodes.remove(at: index)
        reindex()
    }

    public func removeAll() {
        self.rootDataNode.removeChildren(nil)
        self.rootRowsNode.removeChildren(nil)
        self.rootColsNode.removeChildren(nil)
        self.rootFilterNode.removeChildren(nil)
        self.rootNodes.removeAll()
        reindex()
    }

    public func allObjects(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(self.rootNodes).sorted(by: comparator)
    }
    
    @objc
    public func nodesCount(section: Int) -> Int {
        return self.levelIndex[section]?.count ?? 0
    }

    public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        let itemsAtSection = self.levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

    //RootNodeHolderProtocol
    lazy var rootFilterNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root filters")
        self.add(node: result)
        return result
    }()
    lazy var rootColsNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root cols")
        self.add(node: result)
        return result
    }()
    lazy var rootRowsNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root data")
        self.add(node: result)
        return result
    }()
    lazy var rootDataNode: WOTNodeProtocol = {
        let result = self.createNode(name: "root rows")
        self.add(node: result)
        return result
    }()

    func resetIndex() {
        self.index.reset()
        self.index.addNodesToIndex([self.rootFilterNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode])
    }

    func resortMetadata(metadataItems: [WOTNodeProtocol]) {

        self.rootDataNode.removeChildren(nil)
        self.rootRowsNode.removeChildren(nil)
        self.rootColsNode.removeChildren(nil)
        self.rootFilterNode.removeChildren(nil)

        let rows = metadataItems.compactMap { $0 as? WOTPivotRowNodeSwift }
        self.rootRowsNode.addChildArray(rows)

        let cols = metadataItems.compactMap { $0 as? WOTPivotColNodeSwift }
        self.rootColsNode.addChildArray(cols)

        let filters = metadataItems.compactMap { $0 as? WOTPivotFilterNodeSwift }
        self.rootFilterNode.addChildArray(filters)
    }

    func reindexMetaItems() -> Int {

        var result: Int = 0
        let completion: (WOTNodeProtocol)->Void = { (node) in
            node.index = result
            result += 1
        }

        WOTNodeEnumerator.sharedInstance.enumerateAll(node: self.rootFilterNode, comparator: WOTPivotNodeSwift.WOTNodeEmptyComparator, childCompletion: completion)
        WOTNodeEnumerator.sharedInstance.enumerateAll(node: self.rootColsNode, comparator: WOTPivotNodeSwift.WOTNodeNameComparator, childCompletion: completion)
        WOTNodeEnumerator.sharedInstance.enumerateAll(node: self.rootRowsNode, comparator: WOTPivotNodeSwift.WOTNodePredicateComparator, childCompletion: completion)

        return result
    }

}

extension WOTDataModel: WOTNodeCreatorProtocol {
    public func createNode(name: String) -> WOTNodeProtocol {
        let result = WOTNodeSwift(name: name)
        result.isVisible = false
        return result
    }
}


//
//  WOTDataModel.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/11/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTNodeAlias = WOTNode
public typealias WOTNodeComparator = (_ left: WOTNodeAlias, _ right: WOTNodeAlias) -> Bool
typealias WOTIndexTypeAlias = Dictionary<Int, [WOTNodeAlias]>


@objc
public protocol WOTDataModelProtocol: NSObjectProtocol {
    var index: WOTNodeIndexProtocol { get }
    var rootNodes: Set<WOTNodeAlias> { get }
    var levels: Int { get }
    var width: Int { get }
    var endpointsCount: Int { get }
    func reindex()
    func add(node: WOTNodeAlias)
    func remove(node: WOTNodeAlias)
    func removeAll()
    func allObjects(sortComparator: WOTNodeComparator?) -> [WOTNodeAlias]
    func nodesCount(section: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> WOTNodeAlias?
}

@objc
public class WOTDataModel: NSObject, WOTDataModelProtocol {

    lazy public var index: WOTNodeIndexProtocol = {
        return WOTNodeIndex()
    }()
    
    private(set)public var rootNodes: Set<WOTNodeAlias>
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

    //TODO: too complex
    public var endpointsCount: Int {
        var result: Int = 0
        self.rootNodes.forEach { (node) in
            let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: node)
            result += endpoints.count
        }
        return result
    }

    override init() {
        self.rootNodes = []
    }

    public func reindex() {
        self.levelIndex.removeAll()
        let level: Int = 0
        let rootNodes = self.allObjects(sortComparator: nil)
        rootNodes.forEach { (node) in
            self.reindexChildNode(node, atLevel: level)
        }
    }

    private func reindexChildNode(_ node: WOTNodeAlias, atLevel: Int) {
        var itemsAtLevel = self.levelIndex[atLevel] ?? [WOTNodeAlias]()
        itemsAtLevel.append(node)
        self.levelIndex[atLevel] = itemsAtLevel

        guard let wotnode = node as? WOTNodeProtocol else {
            return
        }
        wotnode.children.forEach { (child) in
            if let aliaschild = child as? WOTNodeAlias {
                self.reindexChildNode(aliaschild, atLevel: atLevel + 1)
            }
        }
    }

    public func add(node: WOTNodeAlias) {
        self.rootNodes.insert(node)
        reindex()
    }

    public func remove(node: WOTNodeAlias) {
        self.rootNodes.remove(node)
    }

    public func removeAll() {
        self.rootNodes.removeAll()
        reindex()
    }

    public func allObjects(sortComparator: WOTNodeComparator?) -> [WOTNodeAlias] {
        let comparator = sortComparator ?? self.comparator
        return Array(self.rootNodes).sorted(by: comparator)
    }

    public func nodesCount(section: Int) -> Int {
        return self.levelIndex[section]?.count ?? 0
    }

    public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeAlias? {
        let itemsAtSection = self.levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

}

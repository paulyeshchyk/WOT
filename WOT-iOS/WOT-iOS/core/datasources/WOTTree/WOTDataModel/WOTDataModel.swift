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
public protocol WOTDataModelProtocol: NSObjectProtocol {
    var index: WOTNodeIndexProtocol { get }
    var rootNodes: [WOTNodeProtocol] { get }
    var levels: Int { get }
    var width: Int { get }
    var endpointsCount: Int { get }
    func reindex()
    func add(node: WOTNodeProtocol)
    func remove(node: WOTNodeProtocol)
    func removeAll()
    func allObjects(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol]
    func nodesCount(section: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> WOTNodeProtocol?
}

@objc
public class WOTDataModel: NSObject, WOTDataModelProtocol {

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
    }

    public func removeAll() {
        self.rootNodes.removeAll()
        reindex()
    }

    public func allObjects(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(self.rootNodes).sorted(by: comparator)
    }

    public func nodesCount(section: Int) -> Int {
        return self.levelIndex[section]?.count ?? 0
    }

    public func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        let itemsAtSection = self.levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

}

//
//  WOTLevelIndex.swift
//
//
//  Created by Pavel Yeshchyk on 7/18/18.
//

import Foundation
import WOTPivot

typealias WOTIndexTypeAlias = [Int: [WOTNodeProtocol]]

protocol WOTLevelIndexProtocol {
    var width: Int { get }
    var levels: Int { get }
    func reset()
    func itemsCount(atLevel: Int) -> Int
    func set(itemsCount: Int, atLevel: Int)
    func reindexChildNode(_ node: WOTNodeProtocol, atLevel: Int)
    func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol?
    func indexPath(forNode: WOTNodeProtocol) -> IndexPath?
    func addNodesToIndex(_ nodes: [WOTNodeProtocol])
}

class WOTLevelIndex: WOTLevelIndexProtocol {

    private lazy var levelIndex: WOTIndexTypeAlias = {
        return WOTIndexTypeAlias()
    }()

    var width: Int {
        var result: Int = 0
        self.levelIndex.keys.forEach { (key) in
            let arraycount = self.levelIndex[key]?.count ?? 0
            result = max(result, arraycount)
        }
        return result
    }

    var levels: Int {
        return self.levelIndex.keys.count
    }

    func reset() {
        self.levelIndex.removeAll()
    }

    func itemsCount(atLevel: Int) -> Int {
        return self.levelIndex[atLevel]?.count ?? 0
    }

    func set(itemsCount: Int, atLevel: Int) {

    }

    func reindexChildNode(_ node: WOTNodeProtocol, atLevel: Int) {

        var itemsAtLevel = self.levelIndex[atLevel] ?? [WOTNodeProtocol]()
        itemsAtLevel.append(node)
        self.levelIndex[atLevel] = itemsAtLevel

        node.children.forEach { (child) in
            self.reindexChildNode(child, atLevel: atLevel + 1)
        }
    }

    func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        let itemsAtSection = self.levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

    //TODO: simplify it
    func indexPath(forNode: WOTNodeProtocol) -> IndexPath? {

        var indexPath: IndexPath? = nil
        self.levelIndex.keys.forEach { (key) in
            if let section = self.levelIndex[key] {
                section.forEach({ (node) in
                    if node === forNode {
                        if let row = section.index(where: { $0 === forNode }) {
                            indexPath = IndexPath(row: row, section: key)
                        }
                    }
                })
            }
        }
        return indexPath
    }

    func addNodesToIndex(_ nodes: [WOTNodeProtocol]) {
        let level: Int = 0
        nodes.forEach { (node) in
            self.reindexChildNode(node, atLevel: level)
        }
    }
}

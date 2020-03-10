//
//  WOTConnectorNodeIndex.swift
//
//
//  Created on 7/18/18.
//

import Foundation

typealias WOTIndexTypeAlias = [Int: [WOTNodeProtocol]]

class WOTConnectorNodeIndex: NSObject, WOTConnectorNodeIndexProtocol {

    func add(nodes: [WOTNodeProtocol], level: Any?) {
        nodes.forEach { (node) in
            self.add(node: node, level: level)
        }
    }

    func add(node: WOTNodeProtocol, level: Any?) {
        let atLevel = (level as? Int) ?? 0

        var itemsAtLevel = self.levelIndex[atLevel] ?? [WOTNodeProtocol]()
        itemsAtLevel.append(node)
        self.levelIndex[atLevel] = itemsAtLevel

        self.add(nodes: node.children, level: atLevel + 1)
    }

    func addNodeToIndex(_ node: WOTNodeProtocol) {
        self.add(node: node, level: 0)
    }

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

    func item(indexPath: NSIndexPath) -> WOTNodeProtocol? {
        let itemsAtSection = self.levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

    #warning("simplify it")
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

}

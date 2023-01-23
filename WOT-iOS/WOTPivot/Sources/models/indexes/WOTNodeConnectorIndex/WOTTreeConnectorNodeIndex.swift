//
//  WOTTreeConnectorNodeIndex.swift
//
//
//  Created on 7/18/18.
//

import Foundation

typealias WOTIndexTypeAlias = [Int: [WOTNodeProtocol]]

class WOTTreeConnectorNodeIndex: NSObject, WOTTreeConnectorNodeIndexProtocol {
    func add(nodes: [WOTNodeProtocol], level: NodeLevelType) {
        nodes.forEach { node in
            self.add(node: node, level: level)
        }
    }

    func add(node: WOTNodeProtocol, level: NodeLevelType) {
        var itemsAtLevel = self.levelIndex[level] ?? [WOTNodeProtocol]()
        itemsAtLevel.append(node)
        self.levelIndex[level] = itemsAtLevel

        self.add(nodes: node.children, level: level + 1)
    }

    func addNodeToIndex(_ node: WOTNodeProtocol) {
        self.add(node: node, level: 0)
    }

    private lazy var levelIndex: WOTIndexTypeAlias = {
        WOTIndexTypeAlias()
    }()

    var width: Int {
        var result: Int = 0
        self.levelIndex.keys.forEach { key in
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

    func set(itemsCount: Int, atLevel: NodeLevelType) {}

    func item(indexPath: NSIndexPath) -> WOTNodeProtocol? {
        let itemsAtSection = self.levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

    func indexPath(forNode: WOTNodeProtocol) -> IndexPath? {
        var indexPath: [IndexPath] = []
        self.levelIndex.keys.forEach { key in
            guard let section = self.levelIndex[key] else { return }

            section.forEach { node in
                guard  node === forNode else { return }
                guard let row = section.firstIndex(where: { $0 === forNode }) else { return }

                indexPath.append(IndexPath(row: row, section: key))
            }
        }
        return indexPath.first
    }
}

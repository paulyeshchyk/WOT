//
//  WOTConnectorNodeIndex.swift
//
//
//  Created on 7/18/18.
//

import Foundation

typealias WOTIndexTypeAlias = [Int: [WOTNodeProtocol]]

class WOTTreeConnectorNodeIndex: NSObject, WOTConnectorNodeIndexProtocol {
    func add(nodes: [WOTNodeProtocol], level: Any?) {
        nodes.forEach { node in
            self.add(node: node, level: level)
        }
    }

    func add(node: WOTNodeProtocol, level: Any?) {
        let atLevel = (level as? Int) ?? 0

        var itemsAtLevel = levelIndex[atLevel] ?? [WOTNodeProtocol]()
        itemsAtLevel.append(node)
        levelIndex[atLevel] = itemsAtLevel

        add(nodes: node.children, level: atLevel + 1)
    }

    func addNodeToIndex(_ node: WOTNodeProtocol) {
        add(node: node, level: 0)
    }

    private lazy var levelIndex: WOTIndexTypeAlias = {
        WOTIndexTypeAlias()
    }()

    var width: Int {
        var result: Int = 0
        levelIndex.keys.forEach { key in
            let arraycount = self.levelIndex[key]?.count ?? 0
            result = max(result, arraycount)
        }
        return result
    }

    var levels: Int {
        return levelIndex.keys.count
    }

    func reset() {
        levelIndex.removeAll()
    }

    func itemsCount(atLevel: Int) -> Int {
        return levelIndex[atLevel]?.count ?? 0
    }

    func set(itemsCount _: Int, atLevel _: Int) {}

    func item(indexPath: NSIndexPath) -> WOTNodeProtocol? {
        let itemsAtSection = levelIndex[indexPath.section]
        return itemsAtSection?[indexPath.row]
    }

    func indexPath(forNode: WOTNodeProtocol) -> IndexPath? {
        var indexPath: [IndexPath] = []
        levelIndex.keys.forEach { key in
            guard let section = self.levelIndex[key] else { return }

            section.forEach { node in
                guard node === forNode else { return }
                guard let row = section.firstIndex(where: { $0 === forNode }) else { return }

                indexPath.append(IndexPath(row: row, section: key))
            }
        }
        return indexPath.first
    }
}

//
//  WOTDataModel.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/11/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTDataModel: NSObject, WOTDataModelProtocol {

    lazy var nodeIndex: WOTNodeIndexProtocol = { return WOTNodeIndex() }()
    lazy var rootNodes: [WOTNodeProtocol] = { return [] }()
    lazy private var levelIndex: WOTLevelIndexProtocol = { return WOTLevelIndex() }()
    private var comparator: WOTNodeComparator = { (left, right) in return true }

    var levels: Int { return self.levelIndex.levels }

    var width: Int { return self.levelIndex.width }

    var endpointsCount: Int { return WOTNodeEnumerator.sharedInstance.endpoints(array: self.rootNodes).count }

    var nodes: [WOTNodeProtocol] { return [] }

    func reindexNodes() {
        self.nodeIndex.reset()
        self.nodeIndex.addNodesToIndex(self.nodes)
    }

    func reindexLevels() {
        self.levelIndex.reset()

        let nodes = self.rootNodes(sortComparator: nil)
        self.levelIndex.addNodesToIndex(nodes)
    }

    func add(rootNode: WOTNodeProtocol) {
        self.rootNodes.append(rootNode)
        reindexLevels()
    }

    func remove(rootNode: WOTNodeProtocol) {
        guard let index = (self.rootNodes.index { $0 === rootNode }) else {
            return
        }
        self.rootNodes.remove(at: index)
        reindexLevels()
    }

    func clearRootNodes() {
        self.rootNodes.removeAll()
        reindexLevels()
    }

    func rootNodes(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol] {
        let comparator = sortComparator ?? self.comparator
        return Array(self.rootNodes).sorted(by: comparator)
    }

    func nodesCount(section: Int) -> Int {
        return self.levelIndex.itemsCount(atLevel: section)
    }

    func node(atIndexPath indexPath: NSIndexPath) -> WOTNodeProtocol? {
        return self.levelIndex.node(atIndexPath: indexPath)
    }

}

extension WOTDataModel: WOTNodeCreatorProtocol {
    public func createNode(name: String) -> WOTNodeProtocol {
        let result = WOTNodeSwift(name: name)
        result.isVisible = false
        return result
    }
}

//
//  WOTTree.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/16/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

//typealias WOTNodeComparator = (_ left: WOTNodeProtocol, _ right: WOTNodeProtocol) -> ComparisonResult

@objc
protocol WOTTreeProtocol: NSObjectProtocol {
    var model: WOTDataModel { get set }
    var nodes: [WOTNodeProtocol] { get }
    var levels: Int { get }
    var width: Int { get }
    var endpointsCount: Int { get }
//    var nodeComparator: WOTNodeComparator { get set }
    var rootNodes: [WOTNodeProtocol] { get }
    func nodesCount(sectionIndex: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> WOTNodeProtocol?
    func addNode(node: WOTNodeProtocol)
    func removeNode(node: WOTNodeProtocol)
    func removeAllNodes()
    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol

}

@objc
public class WOTTreeSwift: NSObject {

    var model: WOTDataModel

    @objc
    var levels: Int {
        return self.model.levels
    }

    @objc
    var width: Int {
        return self.model.width
    }

    @objc
    var endpointsCount: Int {
        return self.model.endpointsCount
    }

    @objc
    var rootNodes: [WOTNodeProtocol] {
        return self.model.rootNodes
    }

    @objc
    var nodes: [WOTNodeProtocol] {
        return self.model.allObjects(sortComparator: { (_ , _) -> Bool in
            return true
        })
    }
    
    @objc
    init(dataModel: WOTDataModel) {
        model = dataModel
    }

    @objc
    func nodesCount(sectionIndex: Int) -> Int {
        return self.model.nodesCount(section:sectionIndex)
    }

    @objc
    func node(atIndexPath: NSIndexPath) -> WOTNodeProtocol? {
        return self.model.node(atIndexPath: atIndexPath)
    }

    func addNode(node: WOTNodeProtocol) {
        self.model.add(node: node)
    }

    func removeNode(node: WOTNodeProtocol) {
        self.model.remove(node: node)
    }

    func removeAllNodes() {
        self.model.removeAll()
    }

    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol {
        let roots = self.rootNodes.filter {_ in forPredicate.evaluate(with: nil)}
        if roots.count == 0 {
            let root = WOTNodeSwift(name: "root")
            self.addNode(node: root)
            return root
        } else {
            let root = roots.first
            return root!
        }
    }

}

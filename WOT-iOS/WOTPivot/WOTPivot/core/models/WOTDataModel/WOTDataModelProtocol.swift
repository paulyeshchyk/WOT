//
//  WOTDataModelProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/20/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTNodeComparator = (_ left: WOTNodeProtocol, _ right: WOTNodeProtocol) -> Bool

@objc
public protocol WOTNodeCreatorProtocol {
    var collapseToGroups: Bool { get }
    var useEmptyNode: Bool { get }
    func createEmptyNode() -> WOTNodeProtocol
    func createNode(name: String) -> WOTNodeProtocol
    func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol
    func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [WOTNodeProtocol]
    func createNodeGroup(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol
}

@objc
public protocol WOTDataModelListener: NSObjectProtocol {
    func modelDidLoad()
    func modelDidFailLoad(error: Error)
    func metadataItems() -> [WOTNodeProtocol]
    func modelHasNewDataItem()
}

@objc
public protocol WOTDataModelProtocol {
    var rootNodes: [WOTNodeProtocol] { get }
    var endpointsCount: Int { get }
    func add(rootNode: WOTNodeProtocol)
    func add(nodes: [WOTNodeProtocol])
    func remove(rootNode: WOTNodeProtocol)
    func clearRootNodes()
    func rootNodes(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol]
    func nodesCount(section: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> WOTNodeProtocol?
    func indexPath(forNode: WOTNodeProtocol?) -> IndexPath?
    func loadModel()
}

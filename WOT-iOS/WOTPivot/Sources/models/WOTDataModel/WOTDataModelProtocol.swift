//
//  WOTDataModelProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

public typealias WOTNodeComparator = (_ left: WOTNodeProtocol, _ right: WOTNodeProtocol) -> Bool

@objc
public protocol WOTNodeCreatorProtocol {
    var collapseToGroups: Bool { get }
    var useEmptyNode: Bool { get }
    func createEmptyNode() -> WOTNodeProtocol
    func createNode(name: String) -> WOTNodeProtocol
    func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol
    func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [WOTNodeProtocol]
    func createNodeGroup(name: String, fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol
}

@objc
public protocol WOTDataModelMetadatasource {
    func metadataItems() -> [WOTNodeProtocol]
    func filters() -> [WOTNodeProtocol]
}

@objc
public protocol WOTDataModelListener {
    func didFinishLoadModel(error: Error?)
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

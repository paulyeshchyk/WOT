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
    func createNode(name: String) -> WOTNodeProtocol
    func createNode(fetchedObject: NSFetchRequestResult?, byPredicate: NSPredicate?) -> WOTNodeProtocol
}

@objc
protocol WOTDataModelListener: NSObjectProtocol {
    func modelDidLoad()
    func modelDidFailLoad(error: Error)
    func metadataItems() -> [WOTNodeProtocol]
}

@objc
public protocol WOTDataModelProtocol {
    var rootNodes: [WOTNodeProtocol] { get }
    var levels: Int { get }
    var width: Int { get }
    var endpointsCount: Int { get }
    func add(rootNode: WOTNodeProtocol)
    func remove(rootNode: WOTNodeProtocol)
    func clearRootNodes()
    func rootNodes(sortComparator: WOTNodeComparator?) -> [WOTNodeProtocol]
    func nodesCount(section: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> WOTNodeProtocol?
    func loadModel()
}

//
//  NodeDataModelProtocol.swift
//  WOTPivot
//
//  Created by Paul on 1.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol NodeDataModelProtocol {
    var rootNodes: [NodeProtocol] { get }
    var endpointsCount: Int { get }
    func add(rootNode: NodeProtocol)
    func add(nodes: [NodeProtocol])
    func remove(rootNode: NodeProtocol)
    func clearRootNodes()
    func rootNodes(sortComparator: NodeComparator?) -> [NodeProtocol]
    func nodesCount(section: Int) -> Int
    func node(atIndexPath: NSIndexPath) -> NodeProtocol?
    func indexPath(forNode: NodeProtocol?) -> IndexPath?
    func loadModel()
    func cancelLoad(reason: RequestCancelReasonProtocol)
}

@objc
public protocol NodeDataModelListener {
    func didFinishLoadModel(error: Error?)
}

//
//  NodeCreatorProtocol.swift
//  WOTPivot
//
//  Created by Paul on 1.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

public typealias NodeComparator = (_ left: NodeProtocol, _ right: NodeProtocol) -> Bool

@objc
public protocol NodeCreatorProtocol {
    var collapseToGroups: Bool { get }
    var useEmptyNode: Bool { get }
    func createEmptyNode() -> NodeProtocol
    func createNode(name: String) -> NodeProtocol
    func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> NodeProtocol
    func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [NodeProtocol]
    func createNodeGroup(name: String, fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> NodeProtocol
}

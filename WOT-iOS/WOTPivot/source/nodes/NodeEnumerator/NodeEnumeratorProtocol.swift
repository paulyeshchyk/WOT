//
//  NodeEnumeratorProtocol.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
public protocol NodeEnumeratorProtocol: NSObjectProtocol {
    func endpoints(node: NodeProtocol?) -> [NodeProtocol]?
    func endpoints(array: [NodeProtocol]) -> [NodeProtocol]
    func childrenWidth(siblingNode: NodeProtocol, orValue: Int) -> Int
    func childrenCount(siblingNode: NodeProtocol) -> Int
    func depth(forChildren: [NodeProtocol]?, initialLevel: Int) -> Int
    func allItems(fromNode node: NodeProtocol) -> [NodeProtocol]
    func allItems(fromArray: [NodeProtocol]) -> [NodeProtocol]
    func parentsCount(node: NodeProtocol) -> Int
    func visibleParentsCount(node: NodeProtocol) -> Int
    func enumerateAll(children: [NodeProtocol], comparator: (_ node1: NodeProtocol, _ node2: NodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping WOTNodeProtocolCompletion)
    func enumerateAll(node: NodeProtocol, comparator: (_ node1: NodeProtocol, _ node2: NodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping WOTNodeProtocolCompletion)
}

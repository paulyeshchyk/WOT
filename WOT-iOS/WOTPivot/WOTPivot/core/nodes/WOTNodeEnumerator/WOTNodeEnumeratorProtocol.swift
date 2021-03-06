//
//  WOTNodeEnumeratorProtocol.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
public protocol WOTNodeEnumeratorProtocol: NSObjectProtocol {
    func endpoints(node: WOTNodeProtocol?) -> [WOTNodeProtocol]?
    func endpoints(array: [WOTNodeProtocol]) -> [WOTNodeProtocol]
    func childrenWidth(siblingNode: WOTNodeProtocol, orValue: Int) -> Int
    func childrenCount(siblingNode: WOTNodeProtocol) -> Int
    func depth(forChildren: [WOTNodeProtocol]?, initialLevel: Int) -> Int
    func allItems(fromNode node: WOTNodeProtocol) -> [WOTNodeProtocol]
    func allItems(fromArray: [WOTNodeProtocol]) -> [WOTNodeProtocol]
    func parentsCount(node: WOTNodeProtocol) -> Int
    func visibleParentsCount(node: WOTNodeProtocol) -> Int
    func enumerateAll(children: [WOTNodeProtocol], comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping WOTNodeProtocolCompletion)
    func enumerateAll(node: WOTNodeProtocol, comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping WOTNodeProtocolCompletion)
}

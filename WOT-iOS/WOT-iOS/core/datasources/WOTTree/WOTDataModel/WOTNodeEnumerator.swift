//
//  WOTNodeEnumerator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/11/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTNodeEnumeratorProtocol: NSObjectProtocol {
    func endpoints(node: WOTNodeProtocol) -> [WOTNodeProtocol]
    func endpoints(array: [WOTNodeProtocol]) -> [WOTNodeProtocol]
    func childrenWidth(siblingNode:WOTNodeProtocol, orValue: Int) -> Int
    func childrenCount(siblingNode: WOTNodeProtocol) -> Int
    func depth(forChildren: [WOTNodeProtocol], initialLevel: Int) -> Int
    func allItems(fromNode node: WOTNodeProtocol) -> [WOTNodeProtocol]
    func allItems(fromArray: [WOTNodeProtocol]) -> [WOTNodeProtocol]
    func parentsCount(node: WOTNodeProtocol) -> Int
    func visibleParentsCount(node: WOTNodeProtocol) -> Int
    func enumerateAll(children: [WOTNodeProtocol], comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping(WOTNodeProtocol)->Void)
    func enumerateAll(node: WOTNodeProtocol, comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping(WOTNodeProtocol)->Void)
}

@objc
class WOTNodeEnumerator: NSObject, WOTNodeEnumeratorProtocol {

    @objc
    static let sharedInstance = WOTNodeEnumerator()

    override init() {
        super.init()
    }

    func enumerateAll(node: WOTNodeProtocol, comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping(WOTNodeProtocol)->Void) {
        self.enumerateAll(children: node.children, comparator: comparator, childCompletion: childCompletion)
    }

    func enumerateAll(children: [WOTNodeProtocol], comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping(WOTNodeProtocol)->Void) {
        let sortedItems = children.sorted { (obj1, obj2) -> Bool in
            return comparator(obj1, obj2, -1) == .orderedSame
        }
        sortedItems.forEach { (node) in
            childCompletion(node)
            self.enumerateAll(children: node.children, comparator: comparator, childCompletion: childCompletion)
        }
    }


    func visibleParentsCount(node: WOTNodeProtocol) -> Int {

        guard let parent = node.parent, parent.isVisible else {
            return 0
        }

        var result: Int = 1
        result += self.visibleParentsCount(node: parent)
        return result
    }

    func parentsCount(node: WOTNodeProtocol) -> Int {
        guard let parent = node.parent else {
            return 0
        }

        var result: Int = 1
        result += self.parentsCount(node: parent)
        return result
    }

    func allItems(fromNode node: WOTNodeProtocol) -> [WOTNodeProtocol] {
        return self.allItems(fromArray: node.children)
    }

    func allItems(fromArray array: [WOTNodeProtocol]) -> [WOTNodeProtocol] {
        var result = [WOTNodeProtocol]()
        result.append(contentsOf: array)
        array.forEach { (child) in
            let children = self.allItems(fromArray: child.children)
            result.append(contentsOf: children)
        }
        return result
    }

    func endpoints(node: WOTNodeProtocol) -> [WOTNodeProtocol] {
        guard node.children.count > 0 else {
            return [node]
        }
        return self.endpoints(array: node.children)
    }

    func endpoints(array: [WOTNodeProtocol]) -> [WOTNodeProtocol] {
        var result = [WOTNodeProtocol]()
        array.forEach { (child) in
            let childEndpoints = self.endpoints(node: child)
            result.append(contentsOf: childEndpoints)
        }
        return result
    }

    func childrenWidth(siblingNode:WOTNodeProtocol, orValue: Int) -> Int {
        var result: Int = 0
        guard let parent = siblingNode.parent else {
            return result
        }
        guard let indexOfNode = (parent.children.index { $0 === siblingNode}) else {
            return result
        }
        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: child)
            endpoints.forEach { (node) in
                result += orValue
            }
        }
        result += self.childrenWidth(siblingNode: parent, orValue: orValue)
        return result
    }

    func childrenCount(siblingNode: WOTNodeProtocol) -> Int {
        var result: Int = 0
        guard let parent = siblingNode.parent else {
            return result
        }

        guard let index = (parent.children.index { $0 === siblingNode }) else {
            return result
        }

        for idx in 0 ..< index {
            let child = parent.children[idx]
            let endpoints = self.endpoints(node: child)
            result += endpoints.count
        }
        result += self.childrenCount(siblingNode: parent)
        return result
    }



    func depth(forChildren children: [WOTNodeProtocol], initialLevel: Int) -> Int {
        var result: Int = initialLevel
        children.forEach { (child) in
            let resultFromChild = self.depth(forChildren: child.children, initialLevel: (initialLevel + 1))
            result = max(result, resultFromChild)
        }
        return result
    }

}

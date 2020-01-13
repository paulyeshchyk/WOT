//
//  WOTNodeEnumerator.swift
//  WOT-iOS
//
//  Created on 7/11/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
public class WOTNodeEnumerator: NSObject, WOTNodeEnumeratorProtocol {

    @objc
    public static let sharedInstance = WOTNodeEnumerator()

    override init() {
        super.init()
    }

    public func enumerateAll(node: WOTNodeProtocol, comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping(WOTNodeProtocol) -> Void) {
        self.enumerateAll(children: node.children, comparator: comparator, childCompletion: childCompletion)
    }

    public func enumerateAll(children: [WOTNodeProtocol], comparator: (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping(WOTNodeProtocol) -> Void) {
        let sortedItems = children.sorted { (obj1, obj2) -> Bool in
            return comparator(obj1, obj2, -1) == .orderedSame
        }
        sortedItems.forEach { (node) in
            childCompletion(node)
            self.enumerateAll(children: node.children, comparator: comparator, childCompletion: childCompletion)
        }
    }

    public func visibleParentsCount(node: WOTNodeProtocol) -> Int {

        guard let parent = node.parent, parent.isVisible else {
            return 0
        }

        var result: Int = 1
        result += self.visibleParentsCount(node: parent)
        return result
    }

    public func parentsCount(node: WOTNodeProtocol) -> Int {
        guard let parent = node.parent else {
            return 0
        }

        var result: Int = 1
        result += self.parentsCount(node: parent)
        return result
    }

    public func allItems(fromNode node: WOTNodeProtocol) -> [WOTNodeProtocol] {
        return self.allItems(fromArray: node.children)
    }

    public func allItems(fromArray array: [WOTNodeProtocol]) -> [WOTNodeProtocol] {
        var result = [WOTNodeProtocol]()
        result.append(contentsOf: array)
        array.forEach { (child) in
            let children = self.allItems(fromArray: child.children)
            result.append(contentsOf: children)
        }
        return result
    }

    public func endpoints(node: WOTNodeProtocol?) -> [WOTNodeProtocol]? {
        guard let root = node else {
            return nil
        }

        guard root.children.count > 0 else {
            return [root]
        }

        return self.endpoints(array: root.children)
    }

    public func endpoints(array: [WOTNodeProtocol]) -> [WOTNodeProtocol] {
        var result = [WOTNodeProtocol]()
        array.forEach { (child) in
            if let childEndpoints = self.endpoints(node: child) {
                result.append(contentsOf: childEndpoints)
            }
        }
        return result
    }

    public func childrenWidth(siblingNode: WOTNodeProtocol, orValue: Int) -> Int {
        var result: Int = 0
        guard let parent = siblingNode.parent else {
            return result
        }
        guard let indexOfNode = (parent.children.index { $0 === siblingNode }) else {
            return result
        }
        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = self.endpoints(node: child)
            endpoints?.forEach { (_ ) in
                result += orValue
            }
        }
        result += self.childrenWidth(siblingNode: parent, orValue: orValue)
        return result
    }

    public func childrenCount(siblingNode: WOTNodeProtocol) -> Int {
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
            result += endpoints?.count ?? 0
        }
        result += self.childrenCount(siblingNode: parent)
        return result
    }

    public func depth(forChildren children: [WOTNodeProtocol]?, initialLevel: Int) -> Int {
        var result: Int = initialLevel
        children?.forEach { (child) in
            let resultFromChild = self.depth(forChildren: child.children, initialLevel: (initialLevel + 1))
            result = max(result, resultFromChild)
        }
        return result
    }

}

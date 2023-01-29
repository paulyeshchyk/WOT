//
//  NodeEnumerator.swift
//  WOT-iOS
//
//  Created on 7/11/18.
//  Copyright © 2018. All rights reserved.
//

@objc
public class NodeEnumerator: NSObject, NodeEnumeratorProtocol {

    // MARK: Public

    public func enumerateAll(node: NodeProtocol, comparator: (_ node1: NodeProtocol, _ node2: NodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping WOTNodeProtocolCompletion) {
        enumerateAll(children: node.children, comparator: comparator, childCompletion: childCompletion)
    }

    public func enumerateAll(children: [NodeProtocol], comparator: (_ node1: NodeProtocol, _ node2: NodeProtocol, _ level: Int) -> ComparisonResult, childCompletion: @escaping WOTNodeProtocolCompletion) {
        let sortedItems = children.sorted { (obj1, obj2) -> Bool in
            return comparator(obj1, obj2, -1) == .orderedSame
        }
        sortedItems.forEach { (node) in
            childCompletion(node)
            self.enumerateAll(children: node.children, comparator: comparator, childCompletion: childCompletion)
        }
    }

    public func visibleParentsCount(node: NodeProtocol) -> Int {
        guard let parent = node.parent, parent.isVisible else {
            return 0
        }

        var result: Int = 1
        result += visibleParentsCount(node: parent)
        return result
    }

    public func parentsCount(node: NodeProtocol) -> Int {
        guard let parent = node.parent else {
            return 0
        }

        var result: Int = 1
        result += parentsCount(node: parent)
        return result
    }

    public func allItems(fromNode node: NodeProtocol) -> [NodeProtocol] {
        return allItems(fromArray: node.children)
    }

    public func allItems(fromArray array: [NodeProtocol]) -> [NodeProtocol] {
        var result = [NodeProtocol]()
        result.append(contentsOf: array)
        array.forEach { (child) in
            let children = self.allItems(fromArray: child.children)
            result.append(contentsOf: children)
        }
        return result
    }

    public func endpoints(node: NodeProtocol?) -> [NodeProtocol]? {
        guard let root = node else {
            return nil
        }

        guard !root.children.isEmpty else {
            return [root]
        }

        return endpoints(array: root.children)
    }

    public func endpoints(array: [NodeProtocol]) -> [NodeProtocol] {
        var result = [NodeProtocol]()
        array.forEach { (child) in
            if let childEndpoints = self.endpoints(node: child) {
                result.append(contentsOf: childEndpoints)
            }
        }
        return result
    }

    public func childrenWidth(siblingNode: NodeProtocol, orValue: Int) -> Int {
        var result: Int = 0
        guard let parent = siblingNode.parent else {
            return result
        }
        guard let indexOfNode = (parent.children.firstIndex { $0 === siblingNode }) else {
            return result
        }
        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = self.endpoints(node: child)
            endpoints?.forEach { (_) in
                result += orValue
            }
        }
        result += childrenWidth(siblingNode: parent, orValue: orValue)
        return result
    }

    public func childrenCount(siblingNode: NodeProtocol) -> Int {
        var result: Int = 0
        guard let parent = siblingNode.parent else {
            return result
        }

        guard let index = (parent.children.firstIndex { $0 === siblingNode }) else {
            return result
        }

        for idx in 0 ..< index {
            let child = parent.children[idx]
            let endpoints = self.endpoints(node: child)
            result += endpoints?.count ?? 0
        }
        result += childrenCount(siblingNode: parent)
        return result
    }

    public func depth(forChildren children: [NodeProtocol]?, initialLevel: Int) -> Int {
        var result: Int = initialLevel
        children?.forEach { (child) in
            let resultFromChild = self.depth(forChildren: child.children, initialLevel: (initialLevel + 1))
            result = max(result, resultFromChild)
        }
        return result
    }
}

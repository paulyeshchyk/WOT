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
    func childrenMaxWidth(siblingNode: WOTNodeProtocol, orValue: Int) -> Int
    func depth(forChildren: [WOTNodeProtocol], initialLevel: Int) -> Int
    func allItems(fromArray:[WOTNodeProtocol]) -> [WOTNodeProtocol]
    func parentsCount(node: WOTNodeProtocol) -> Int
    func visibleParentsCount(node: WOTNodeProtocol) -> Int
}

@objc
class WOTNodeEnumerator: NSObject, WOTNodeEnumeratorProtocol {

    @objc
    static let sharedInstance = WOTNodeEnumerator()

    override init() {
        super.init()
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

    func maxWidth(node: WOTNodeProtocol, orValue: Int) -> Int {
        return 0
    }

    func childrenMaxWidth(siblingNode: WOTNodeProtocol, orValue: Int) -> Int {

        guard let parent = siblingNode.parent else {
            return 0
        }

        guard let siblingIndex = (parent.children.index { $0 === siblingNode }) else {
            return 0
        }
        var result: Int = 0
        for idx in 0 ..< siblingIndex {
            let child = parent.children[idx]
            let endpoints = self.endpoints(node: child)
            endpoints.forEach { (node) in
                result += self.maxWidth(node: node, orValue: orValue)
            }
        }
        result += self.childrenMaxWidth(siblingNode: parent, orValue: orValue)
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

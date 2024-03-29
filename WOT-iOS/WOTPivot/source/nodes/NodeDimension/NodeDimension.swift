//
//  NodeDimension.swift
//  WOT-iOS
//
//  Created on 7/13/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

typealias TNodeSize = [String: Int]
typealias TNodesSizesType = [AnyHashable: TNodeSize]

// MARK: - NodeDimension

public class NodeDimension: NSObject, NodeDimensionProtocol {

    public weak var fetchController: NodeFetchControllerProtocol?
    public weak var enumerator: NodeEnumeratorProtocol?

    public var shouldDisplayEmptyColumns: Bool {
        return false
    }

    public var contentSize: CGSize {
        return .zero
    }

    private lazy var sizes: TNodesSizesType = TNodesSizesType()

    // MARK: Public

    public func setMaxWidth(_ maxWidth: Int, forNode: NodeProtocol, byKey: String) {
        guard maxWidth != 0 else {
            return
        }

        var nodeSizes = TNodeSize()

        if let oldSizes = sizeMap(node: forNode) {
            oldSizes.keys.forEach { (key) in
                nodeSizes[key] = oldSizes[key]
            }
        }
        var value = 0
        if let nodeSizesValue = nodeSizes[byKey] {
            value = nodeSizesValue
        }

        let maxValue = max(value, maxWidth)
        nodeSizes[byKey] = maxValue
        set(sizeMap: nodeSizes, node: forNode)
    }

    public func maxWidth(_ node: NodeProtocol, orValue: Int) -> Int {
        var result = orValue

        guard let nodeSizes = sizeMap(node: node) else {
            return result
        }
        nodeSizes.keys.forEach { (key) in
            if let oldValue = nodeSizes[key] {
                result = max(oldValue, result)
            }
        }
        return result
    }

    public func childrenMaxWidth(_ node: NodeProtocol, orValue: Int) -> Int {
        guard let parent = node.parent else {
            return 0
        }
        guard let indexOfNode = (parent.children.firstIndex { $0 === node }) else {
            return 0
        }

        var result: Int = 0
        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = enumerator?.endpoints(node: child)
            endpoints?.forEach { (endpoint) in
                result += self.maxWidth(endpoint, orValue: orValue)
            }
        }
        result += childrenMaxWidth(parent, orValue: orValue)
        return result
    }

    public func reload(forIndex _: Int, nodeCreator _: NodeCreatorProtocol?) {
        preconditionFailure("This method must be overridden")
    }

    // MARK: Private

    private func sizeMap(node: NodeProtocol) -> TNodeSize? {
        if let obj = node as? AnyHashable {
            return sizes[obj]
        }
        return nil
    }

    private func set(sizeMap: TNodeSize, node: NodeProtocol) {
        if let obj = node as? AnyHashable {
            sizes[obj] = sizeMap
        }
    }
}

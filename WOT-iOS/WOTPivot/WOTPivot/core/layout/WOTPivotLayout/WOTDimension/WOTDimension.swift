//
//  WOTDimension.swift
//  WOT-iOS
//
//  Created on 7/13/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

typealias TNodeSize = [String: Int]
typealias TNodesSizesType = [AnyHashable: TNodeSize]

public class WOTDimension: NSObject, WOTDimensionProtocol {

    required public init(fetchController: WOTDataFetchControllerProtocol, enumerator: WOTNodeEnumeratorProtocol) {
        self.fetchController = fetchController
        self.enumerator = enumerator
    }

    var fetchController: WOTDataFetchControllerProtocol
    var enumerator: WOTNodeEnumeratorProtocol

    lazy private var sizes: TNodesSizesType = {
        return TNodesSizesType()
    }()

    private func sizeMap(node: WOTNodeProtocol) -> TNodeSize? {
        if let obj = node as? AnyHashable {
            return sizes[obj]
        }
        return nil
    }

    private func set(sizeMap: TNodeSize, node: WOTNodeProtocol) {
        if let obj = node as? AnyHashable {
            sizes[obj] = sizeMap
        }
    }

    public func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String) {
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

    public func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int {
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

    public func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int {
        guard let parent = node.parent else {
            return 0
        }
        guard let indexOfNode = (parent.children.index { $0 === node }) else {
            return 0
        }

        var result: Int = 0
        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = self.enumerator.endpoints(node: child)
            endpoints.forEach { (endpoint) in
                result += self.maxWidth(endpoint, orValue: orValue)
            }
        }
        result += self.childrenMaxWidth(parent, orValue: orValue)
        return result
    }

    public var shouldDisplayEmptyColumns: Bool {
        return false
    }

    public var contentSize: CGSize {
        return .zero
    }

    public func reload(forIndex externalIndex: Int, nodeCreator: WOTNodeCreatorProtocol?) {
        preconditionFailure("This method must be overridden")
    }

}

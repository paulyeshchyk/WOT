//
//  WOTDimension.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/13/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
typealias TNodeSize = [String: Int]
typealias TNodesSizesType = [AnyHashable: TNodeSize]

@objc
class WOTDimension: NSObject, WOTDimensionProtocol {

    required init(fetchController: WOTDataFetchControllerProtocol) {
        self.fetchController = fetchController
    }

    var fetchController: WOTDataFetchControllerProtocol

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

    func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String) {
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

    func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int {
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

    func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int {
        guard let parent = node.parent else {
            return 0
        }
        guard let indexOfNode = (parent.children.index { $0 === node }) else {
            return 0
        }

        var result: Int = 0
        for idx in 0 ..< indexOfNode {
            let child = parent.children[idx]
            let endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: child)
            endpoints.forEach { (endpoint) in
                result += self.maxWidth(endpoint, orValue: orValue)
            }
        }
        result += self.childrenMaxWidth(parent, orValue: orValue)
        return result
    }

    var shouldDisplayEmptyColumns: Bool {
        return false
    }

    var contentSize: CGSize {
        return .zero
    }

    func reload(forIndex externalIndex: Int, completion: ()->()) {
        preconditionFailure("This method must be overridden")
    }

}

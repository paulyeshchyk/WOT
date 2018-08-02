//
//  WOTPivotPermutator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/2/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTPivotPermutator: NSObject {

    @objc
    func permutate(pivotNodes: [WOTPivotNodeProtocol], as type: PivotMetadataType) -> [WOTPivotNodeProtocol]? {

        guard let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type) as? WOTPivotNode.Type else {
            return nil
        }

        let result = pivotNodeClass.init(name: "-")
        result.isVisible = true

        var mutablePivotNodes = pivotNodes

        var endpoints: [WOTPivotNodeProtocol]? = nil
        if let nextPivotNode = mutablePivotNodes.popLast() {
            endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [WOTPivotNodeProtocol]
        }

        iterateMiddle(pivotNodes: mutablePivotNodes, endpoints: endpoints, addToParent: result)

        return [result]
    }

    private func iterateMiddle(pivotNodes: [WOTPivotNodeProtocol], endpoints: [WOTPivotNodeProtocol]?, addToParent: WOTPivotNodeProtocol?) {

        var mutablePivotNodes = pivotNodes
        var nextEndPoints: [WOTPivotNodeProtocol]? = nil
        if let nextPivotNode = mutablePivotNodes.popLast() {
            nextEndPoints = WOTNodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [WOTPivotNodeProtocol]
        }

        endpoints?.forEach { (endpoint) in

            let result: WOTPivotNodeProtocol = endpoint.copy(with: nil) as! WOTPivotNodeProtocol
            addToParent?.addChild(result)

            if mutablePivotNodes.count > 0 {
                iterateMiddle(pivotNodes: mutablePivotNodes, endpoints: nextEndPoints, addToParent: result)
            } else {
                let subpredicates: [NSPredicate?] = [endpoint.predicate]
                iterateLast(endpoints: nextEndPoints, addToParent: result, predicates: subpredicates)
            }
        }
    }

    private func iterateLast(endpoints: [WOTPivotNodeProtocol]?, addToParent: WOTPivotNodeProtocol, predicates: [NSPredicate?]) {

        endpoints?.forEach({ (endpoint) in
            var subpredicates = predicates.compactMap { $0 }
            if let predicate = endpoint.predicate {
                subpredicates.append(predicate)
            }

            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates.compactMap { $0 })
            let result: WOTPivotNodeProtocol = endpoint.copy(with: nil) as! WOTPivotNodeProtocol
            result.predicate = predicate
            addToParent.addChild(result)
        })
    }
}

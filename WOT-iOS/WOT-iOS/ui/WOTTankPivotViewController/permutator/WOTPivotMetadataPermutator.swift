//
//  WOTPivotMetadataPermutator.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/2/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

struct WOTPivotMetadataPermutator {

    func permutate(templates: [WOTPivotTemplateProtocol], as type: PivotMetadataType) -> [WOTPivotNodeProtocol] {

        var mutableTemplates = [WOTPivotNodeProtocol]()
        templates.forEach { (template) in
            let templateNode = template.asType(type)
            mutableTemplates.append(templateNode)
        }

        var endpoints: [WOTPivotNodeProtocol]? = nil
        if let nextPivotNode = mutableTemplates.popLast() {
            endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [WOTPivotNodeProtocol]
        }

        return iterateMiddle(templates: mutableTemplates, endpoints: endpoints)
    }

    private func iterateMiddle(templates: [WOTPivotNodeProtocol], endpoints: [WOTPivotNodeProtocol]?) -> [WOTPivotNodeProtocol] {

        var resultArray = [WOTPivotNodeProtocol]()
        var mutablePivotNodes = templates
        var nextEndPoints: [WOTPivotNodeProtocol]? = nil
        if let nextPivotNode = mutablePivotNodes.popLast() {
            nextEndPoints = WOTNodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [WOTPivotNodeProtocol]
        }

        endpoints?.forEach { (endpoint) in

            if let result: WOTPivotNodeProtocol = endpoint.copy(with: nil) as? WOTPivotNodeProtocol {

                resultArray.append(result)

                if mutablePivotNodes.count > 0 {
                    let children = iterateMiddle(templates: mutablePivotNodes, endpoints: nextEndPoints)
                    result.addChildArray(children)
                } else {
                    let subpredicates: [NSPredicate?] = [endpoint.predicate]
                    let children = iterateLast(endpoints: nextEndPoints, predicates: subpredicates)
                    result.addChildArray(children)
                }
            }
        }
        return resultArray
    }

    private func iterateLast(endpoints: [WOTPivotNodeProtocol]?, predicates: [NSPredicate?]) -> [WOTPivotNodeProtocol] {

        var resultArray = [WOTPivotNodeProtocol]()
        endpoints?.forEach({ (endpoint) in
            var subpredicates = predicates.compactMap { $0 }
            if let predicate = endpoint.predicate {
                subpredicates.append(predicate)
            }

            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates.compactMap { $0 })
            if let result: WOTPivotNodeProtocol = endpoint.copy(with: nil) as? WOTPivotNodeProtocol {
                result.predicate = predicate
                resultArray.append(result)
            }
        })
        return resultArray
    }
}

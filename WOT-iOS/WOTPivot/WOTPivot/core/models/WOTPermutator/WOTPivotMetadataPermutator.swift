//
//  WOTPivotMetadataPermutator.swift
//  WOT-iOS
//
//  Created on 8/2/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol WOTPivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol
}

@objc
public class WOTPivotMetaTypeConverter: NSObject {
    @objc
    public static func nodeClass(for type: PivotMetadataType) -> WOTPivotNode.Type {
        switch type {
        case .filter:
            return WOTPivotFilterNode.self
        case .column:
            return WOTPivotColNode.self
        case .row:
            return WOTPivotRowNode.self
        case .data:
            return WOTPivotDataNode.self
        @unknown default:
            fatalError("unknown pivotnode type")
        }
    }
}

public struct WOTPivotMetadataPermutator {
    public init() {}

    public func permutate(templates: [WOTPivotTemplateProtocol], as type: PivotMetadataType) -> [WOTPivotNodeProtocol] {
        var mutableTemplates = [WOTPivotNodeProtocol]()
        templates.forEach { (template) in
            let templateNode = template.asType(type)
            mutableTemplates.append(templateNode)
        }

        var endpoints: [WOTPivotNodeProtocol]?
        if let nextPivotNode = mutableTemplates.popLast() {
            endpoints = WOTNodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [WOTPivotNodeProtocol]
        }

        return iterateMiddle(templates: mutableTemplates, endpoints: endpoints)
    }

    private func iterateMiddle(templates: [WOTPivotNodeProtocol], endpoints: [WOTPivotNodeProtocol]?) -> [WOTPivotNodeProtocol] {
        var resultArray = [WOTPivotNodeProtocol]()
        var mutablePivotNodes = templates
        var nextEndPoints: [WOTPivotNodeProtocol]?
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

            #warning("makes dublicated predicates WTF???")
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates.compactMap { $0 })
            if let result: WOTPivotNodeProtocol = endpoint.copy(with: nil) as? WOTPivotNodeProtocol {
                result.predicate = predicate
                resultArray.append(result)
            }
        })
        return resultArray
    }
}

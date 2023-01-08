//
//  WOTPivotMetadataPermutator.swift
//  WOT-iOS
//
//  Created on 8/2/18.
//  Copyright © 2018. All rights reserved.
//

// MARK: - PivotMetadataPermutator

public struct PivotMetadataPermutator {

    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public func permutate(templates: [PivotTemplateProtocol], as type: PivotMetadataType) -> [PivotNodeProtocol] {
        var mutableTemplates = [PivotNodeProtocol]()
        templates.forEach { (template) in
            let templateNode = template.asType(type)
            mutableTemplates.append(templateNode)
        }

        var endpoints: [PivotNodeProtocol]?
        if let nextPivotNode = mutableTemplates.popLast() {
            endpoints = NodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [PivotNodeProtocol]
        }

        return iterateMiddle(templates: mutableTemplates, endpoints: endpoints)
    }

    // MARK: Private

    private func iterateMiddle(templates: [PivotNodeProtocol], endpoints: [PivotNodeProtocol]?) -> [PivotNodeProtocol] {
        var resultArray = [PivotNodeProtocol]()
        var mutablePivotNodes = templates
        var nextEndPoints: [PivotNodeProtocol]?
        if let nextPivotNode = mutablePivotNodes.popLast() {
            nextEndPoints = NodeEnumerator.sharedInstance.endpoints(node: nextPivotNode) as? [PivotNodeProtocol]
        }

        endpoints?.forEach { (endpoint) in

            if let result: PivotNodeProtocol = endpoint.copy(with: nil) as? PivotNodeProtocol {
                resultArray.append(result)

                if !mutablePivotNodes.isEmpty {
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

    private func iterateLast(endpoints: [PivotNodeProtocol]?, predicates: [NSPredicate?]) -> [PivotNodeProtocol] {
        var resultArray = [PivotNodeProtocol]()
        endpoints?.forEach { (endpoint) in
            var subpredicates = predicates.compactMap { $0 }
            if let predicate = endpoint.predicate {
                subpredicates.append(predicate)
            }

            #warning("makes dublicated predicates WTF???")
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates.compactMap { $0 })
            if let result: PivotNodeProtocol = endpoint.copy(with: nil) as? PivotNodeProtocol {
                result.predicate = predicate
                resultArray.append(result)
            }
        }
        return resultArray
    }
}

// MARK: - PivotTemplateProtocol

public protocol PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol
}

// MARK: - PivotMetaTypeConverter

@objc
public class PivotMetaTypeConverter: NSObject {
    @objc
    public static func nodeClass(for type: PivotMetadataType) -> PivotNode.Type {
        switch type {
        case .filter:
            return FilterPivotNode.self
        case .column:
            return ColPivotNode.self
        case .row:
            return RowPivotNode.self
        case .data:
            return DataPivotNode.self
        @unknown default:
            fatalError("unknown pivotnode type")
        }
    }
}

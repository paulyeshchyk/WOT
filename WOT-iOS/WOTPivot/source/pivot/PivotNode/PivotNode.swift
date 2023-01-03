//
//  PivotNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public class PivotNode: Node, PivotNodeProtocol {

    @objc
    public required init(name nameValue: String, predicate predicateValue: NSPredicate) {
        predicate = predicateValue
        super.init(name: nameValue)
    }

    @objc
    public required init(name nameValue: String) {
        super.init(name: nameValue)
    }

    override open func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: name)
        result.predicate = predicate?.copy(with: zone) as? NSPredicate
        result.dataColor = dataColor?.copy(with: zone) as? UIColor
        result.isVisible = isVisible
        result.imageURL = imageURL?.copy(with: zone) as? NSURL
        return result
    }

    public var dataColor: UIColor?
    public var data1: AnyObject?
    public var predicate: NSPredicate?
    public var indexInsideStepParentColumn: Int = 0
    public var stepParentColumn: NodeProtocol?
    public var stepParentRow: NodeProtocol?
    public var imageURL: NSURL?
    public var relativeRect: NSValue?

    public var stickyType: PivotStickyType { return .float }
    public var cellType: PivotCellType { return .data }
    public var fullPredicate: NSPredicate? {
        guard let parentPredicate = (parent as? PivotNodeProtocol)?.fullPredicate else {
            return predicate
        }
        let selfPredicate = predicate
        let predicates: [NSPredicate] = [selfPredicate, parentPredicate].compactMap { $0 }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}

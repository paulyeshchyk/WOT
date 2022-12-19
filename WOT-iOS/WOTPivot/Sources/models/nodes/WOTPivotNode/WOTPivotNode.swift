//
//  WOTPivotNode.swift
//  WOT-iOS
//
//  Created on 7/17/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public class WOTPivotNode: WOTNode, WOTPivotNodeProtocol {
    public var dataColor: UIColor?
    public var data1: AnyObject?
    public var stickyType: PivotStickyType { return .float }
    public var cellType: WOTPivotCellType { return .data }
    public var predicate: NSPredicate?
    public var fullPredicate: NSPredicate? {
        guard let parentPredicate = (self.parent as? WOTPivotNodeProtocol)?.fullPredicate else {
            return self.predicate
        }
        let selfPredicate = self.predicate
        let predicates: [NSPredicate] = [selfPredicate, parentPredicate].compactMap { $0 }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    public var indexInsideStepParentColumn: Int = 0
    public var stepParentColumn: WOTNodeProtocol?
    public var stepParentRow: WOTNodeProtocol?
    public var imageURL: NSURL?
    public var relativeRect: NSValue?

    @objc
    public required init(name nameValue: String, predicate predicateValue: NSPredicate) {
        predicate = predicateValue
        super.init(name: nameValue)
    }

    @objc
    public required init(name nameValue: String) {
        super.init(name: nameValue)
    }

    open override func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: self.name)
        result.predicate = self.predicate?.copy(with: zone) as? NSPredicate
        result.dataColor = self.dataColor?.copy(with: zone) as? UIColor
        result.isVisible = self.isVisible
        result.imageURL = self.imageURL?.copy(with: zone) as? NSURL
        return result
    }
}

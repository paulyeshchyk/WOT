//
//  WOTPivotNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

class WOTPivotNode: WOTNode, WOTPivotNodeProtocol {


    var dataColor: UIColor?
    var data1: NSManagedObject?
    var stickyType: PivotStickyType { return .float }
    var cellType: WOTPivotCellType { return .data }
    var predicate: NSPredicate?
    var fullPredicate: NSPredicate? {

        var predicates = [NSPredicate?]()
        if let parentPredicate = (self.parent as? WOTPivotNodeProtocol)?.fullPredicate {
            predicates.append(parentPredicate)
        }
        predicates.append(self.predicate)
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates.compactMap{$0})

    }
    public var indexInsideStepParentColumn: Int = 0
    public var stepParentColumn: WOTNodeProtocol?
    public var stepParentRow: WOTNodeProtocol?
    public var imageURL: NSURL?
    public var relativeRect: NSValue?

    @objc
    required init(name nameValue: String, predicate predicateValue: NSPredicate) {
        predicate = predicateValue
        super.init(name: nameValue)
    }

    @objc public required init(name nameValue: String) {

        super.init(name: nameValue)
    }

    public override func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: self.name)
        result.predicate = self.predicate?.copy(with: zone) as? NSPredicate
        result.dataColor = self.dataColor?.copy(with: zone) as? UIColor
        result.isVisible = self.isVisible
        result.imageURL = self.imageURL?.copy(with: zone) as? NSURL
        return result
    }

}

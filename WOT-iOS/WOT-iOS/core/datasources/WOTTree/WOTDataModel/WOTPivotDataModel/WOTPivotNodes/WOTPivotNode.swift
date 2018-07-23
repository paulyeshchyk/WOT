//
//  WOTPivotNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

class WOTPivotNodeSwift: WOTNodeSwift, WOTPivotNodeProtocol {

    static let WOTNodePredicateComparator: WOTNodeComparatorType = { (node1, node2, level) in
        if let predicate1 = (node1 as? WOTPivotNodeProtocol)?.predicate, let predicate2 = (node2 as? WOTPivotNodeProtocol)?.predicate {
            return predicate1.predicateFormat.compare(predicate2.predicateFormat)
        } else {
            return ComparisonResult.orderedAscending
        }
    }

    var dataColor: UIColor?
    var data1: NSManagedObject?
    var stickyType: PivotStickyType { return .float }
    var predicate: NSPredicate?
    public var indexInsideStepParentColumn: Int = 0
    public var stepParentColumn: WOTNodeProtocol?
    public var stepParentRow: WOTNodeProtocol?
    public var imageURL: NSURL?
    public var relativeRect: NSValue?

    @objc
    convenience init(name nameValue: String, predicate predicateValue: NSPredicate) {
        self.init(name: nameValue)
        self.predicate = predicateValue
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
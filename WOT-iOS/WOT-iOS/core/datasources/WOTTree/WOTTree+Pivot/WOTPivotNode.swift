//
//  WOTPivotNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

@objc
protocol WOTPivotNodeProtocol: WOTNodeProtocol {
    var dataColor: UIColor { get set }
    var data1: NSManagedObject? { get set }
    var stickyType: PivotStickyType  { get }
    var predicate: NSPredicate?  { get set }
}

class WOTPivotNodeSwift: WOTNodeSwift, WOTPivotNodeProtocol {

    var dataColor: UIColor = UIColor.clear
    var data1: NSManagedObject?
    var stickyType: PivotStickyType { return .float }
    var predicate: NSPredicate?

    @objc
    convenience init(name nameValue: String, predicate predicateValue: NSPredicate) {
        self.init(name: nameValue)
        self.predicate = predicateValue
    }

    public override func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: self.name)
        result.predicate = self.predicate
        result.dataColor = self.dataColor
        result.isVisible = self.isVisible
        result.imageURL = self.imageURL
        return result;
    }
}

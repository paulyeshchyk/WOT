//
//  WOTPivotNodeProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/20/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
@objc
enum WOTPivotCellType: Int {
    case filter
    case column
    case row
    case data
}

@objc
protocol WOTPivotNodeProtocol: WOTNodeProtocol {
    var imageURL: NSURL? { get set }
    var dataColor: UIColor? { get set }
    var data1: NSManagedObject? { get set }
    var stickyType: PivotStickyType { get }
    var cellType: WOTPivotCellType { get }
    var predicate: NSPredicate? { get set }
    var fullPredicate: NSPredicate? { get }
    var relativeRect: NSValue? { get set }
    var indexInsideStepParentColumn: Int { get set }
    var stepParentColumn: WOTNodeProtocol? { get set }
    var stepParentRow: WOTNodeProtocol? { get set }
}

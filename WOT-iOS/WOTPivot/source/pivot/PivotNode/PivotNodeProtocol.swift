//
//  PivotNodeProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - PivotNodeProtocol

@objc
public protocol PivotNodeProtocol: NodeProtocol {
    var imageURL: NSURL? { get set }
    var dataColor: UIColor? { get set }
    var data1: AnyObject? { get set }
    var stickyType: PivotStickyType { get }
    var cellType: PivotCellType { get }
    var predicate: NSPredicate? { get set }
    var fullPredicate: NSPredicate? { get }
    var relativeRect: NSValue? { get set }
    var indexInsideStepParentColumn: Int { get set }
    var stepParentColumn: NodeProtocol? { get set }
    var stepParentRow: NodeProtocol? { get set }
}

// MARK: - PivotCellType

@objc
public enum PivotCellType: Int {
    case filter
    case column
    case row
    case data
    case dataGroup
}

// MARK: - PivotMetadataType

@objc
public enum PivotMetadataType: Int {
    case filter
    case column
    case row
    case data
}

//
//  WOTTankPivotLayout.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/25/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol PivotLayoutCellAttributesProtocol: NSObjectProtocol {
    var rect: CGRect { get }
    var zIndex: Int { get }
    init(rect: CGRect, zIndex: Int)
    func collectionViewLayoutAttributes(rect: CGRect, indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}

import CoreGraphics
import UIKit

@objc
class PivotLayoutCellAttributes: NSObject, PivotLayoutCellAttributesProtocol {
    var rect: CGRect
    var zIndex: Int
    required init(rect r: CGRect, zIndex idx: Int) {
        rect = r
        zIndex = idx
    }

    func collectionViewLayoutAttributes(rect: CGRect, indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard self.rect.intersects(rect) == true else {
            return nil
        }

        let result = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        result.frame = self.rect
        result.zIndex = self.zIndex
        return result
    }
}

extension WOTTankPivotLayout {

    @objc
    func relativeRect(indexPath: IndexPath) -> CGRect {
        guard let block = self.itemRelativeRectCallback else {
            return CGRect.zero
        }
        return block(indexPath)
    }
    @objc
    func stickyType(indexPath: IndexPath) -> PivotStickyType {
        guard let block = self.itemLayoutStickyType else {
            return .float
        }
        return block(indexPath)
    }

    @objc
    func pivotLayoutCellAttributes(indexPath: IndexPath, contentOffset: CGPoint, zIndex: Int) -> PivotLayoutCellAttributes {
        let relativeRect = self.relativeRect(indexPath: indexPath)
        let stickyType = self.stickyType(indexPath: indexPath)
        let itemSize = self.itemSize

        var x = relativeRect.origin.x * itemSize.width
        var y = relativeRect.origin.y * itemSize.height

        let width = relativeRect.size.width * itemSize.width
        let height = relativeRect.size.height * itemSize.height

        var newZIndex = zIndex
        if (stickyType.rawValue & PivotStickyType.vertical.rawValue) == PivotStickyType.vertical.rawValue {
            y += contentOffset.y
            newZIndex += 1
        }
        if (stickyType.rawValue & PivotStickyType.horizontal.rawValue) == PivotStickyType.horizontal.rawValue {
            x += contentOffset.x
            newZIndex += 1
        }
        let resultRect = CGRect(x: x, y: y, width: width, height: height)
        return PivotLayoutCellAttributes(rect: resultRect, zIndex: newZIndex)
    }

    override open var collectionViewContentSize: CGSize {
        get {
            guard let block = self.relativeContentSizeBlock else {
                return .zero
            }
            let relativeSize = block()
            let width = relativeSize.width * self.itemSize.width
            let height = relativeSize.height * self.itemSize.height
            return CGSize(width: width, height: height)
        }
        set {
        }
    }
}

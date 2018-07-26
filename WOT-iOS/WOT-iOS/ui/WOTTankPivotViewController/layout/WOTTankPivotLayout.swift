//
//  WOTTankPivotLayout.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/25/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTTankPivotLayoutProtocol {
    var relativeContentSizeBlock: (() -> CGSize)? { get set }
    var itemRelativeRectCallback: ((IndexPath) -> CGRect)? { get set }
    var itemLayoutStickyType: ((IndexPath) -> PivotStickyType)? { get set }
}

class WOTTankPivotLayout: UICollectionViewFlowLayout, WOTTankPivotLayoutProtocol {
    var relativeContentSizeBlock: (() -> CGSize)?
    var itemRelativeRectCallback: ((IndexPath) -> CGRect)?
    var itemLayoutStickyType: ((IndexPath) -> PivotStickyType)?

    override open var itemSize: CGSize {
        get {
            return Constants.itemSize
        }
        set {

        }
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

    override open func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath)
    }

    override open func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath)
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else {
            return nil
        }

        var result = [UICollectionViewLayoutAttributes]()
        let contentOffset = collectionView.contentOffset

        for section in 0 ..< collectionView.numberOfSections {
            for row in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = NSIndexPath(row: row, section: section)
                let pivotAttributes = self.pivotLayoutCellAttributes(indexPath: indexPath as IndexPath, contentOffset: contentOffset, zIndex: 0)
                if let cellAttributes = pivotAttributes.collectionViewLayoutAttributes(forRect: rect) {
                    result.append(cellAttributes)
                }
            }
        }
        return result
    }
}

extension WOTTankPivotLayout {

    fileprivate struct Constants {
        static let ipadCellSize = CGSize(width: 88, height: 66)
        static let iphoneCellSize = CGSize(width: 66, height: 44)
        static let itemSize = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? ipadCellSize : iphoneCellSize
    }

    private func relativeRect(indexPath: IndexPath) -> CGRect {
        guard let block = self.itemRelativeRectCallback else {
            return CGRect.zero
        }
        return block(indexPath)
    }

    private func stickyType(indexPath: IndexPath) -> PivotStickyType {
        guard let block = self.itemLayoutStickyType else {
            return .float
        }
        return block(indexPath)
    }

    private func pivotLayoutCellAttributes(indexPath: IndexPath, contentOffset: CGPoint, zIndex: Int) -> PivotLayoutCellAttributes {
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
        let cellRect = CGRect(x: x, y: y, width: width, height: height)
        return PivotLayoutCellAttributes(cellRect: cellRect, cellZIndex: newZIndex, cellIndexPath: indexPath)
    }
}

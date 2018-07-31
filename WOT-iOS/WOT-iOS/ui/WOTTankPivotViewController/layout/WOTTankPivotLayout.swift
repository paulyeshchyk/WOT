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

class WOTColoredLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = WOTPivotSeparatorLayoutAttributes(forDecorationViewOfKind: elementKind,
            with: indexPath)

        layoutAttributes.color = UIColor.darkGray
        layoutAttributes.zIndex = -1
        return layoutAttributes
    }
}

class WOTTankPivotLayout: WOTColoredLayout, WOTTankPivotLayoutProtocol {
    var relativeContentSizeBlock: (() -> CGSize)?
    var itemRelativeRectCallback: ((IndexPath) -> CGRect)?
    var itemLayoutStickyType: ((IndexPath) -> PivotStickyType)?

    override func prepare() {
        super.prepare()
        register(WOTPivotSeparatorView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.top.rawValue)
        register(WOTPivotSeparatorView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.left.rawValue)
        register(WOTPivotSeparatorView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.right.rawValue)
        register(WOTPivotSeparatorView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.bottom.rawValue)
    }

    override open var itemSize: CGSize {
        get {
            return Constants.itemSize
        }
        set {

        }
    }

    override open var collectionViewContentSize: CGSize {
        get {
            let relativeSize = self.relativeSize()
            let itemSize = self.itemSize
            let width = relativeSize.width * itemSize.width
            let height = relativeSize.height * itemSize.height
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
        var result = [UICollectionViewLayoutAttributes]()
        guard let collectionView = self.collectionView else {
            return result
        }

        let contentOffset = collectionView.contentOffset

        for section in 0 ..< collectionView.numberOfSections {
            for row in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let pivotAttributes = self.pivotLayoutCellAttributes(indexPath: indexPath, contentOffset: contentOffset)
                if let cellAttributes = pivotAttributes.collectionViewLayoutAttributes(forRect: rect) {
                    result.append(contentsOf: cellAttributes)

                    if let decor = layoutAttributesForDecorationView(ofKind: WOTPivotSeparatorKind.right.rawValue, at: indexPath) as? WOTPivotSeparatorLayoutAttributes {
                        decor.customFrame = pivotAttributes.rect
                        decor.kind = .right
                        decor.zIndex = pivotAttributes.zIndex
                        result.append(decor)
                    }
                    if let decor = layoutAttributesForDecorationView(ofKind: WOTPivotSeparatorKind.left.rawValue, at: indexPath) as? WOTPivotSeparatorLayoutAttributes {
                        decor.customFrame = pivotAttributes.rect
                        decor.kind = .left
                        decor.zIndex = pivotAttributes.zIndex
                        result.append(decor)
                    }
                    if let decor = layoutAttributesForDecorationView(ofKind: WOTPivotSeparatorKind.top.rawValue, at: indexPath) as? WOTPivotSeparatorLayoutAttributes {
                        decor.customFrame = pivotAttributes.rect
                        decor.kind = .top
                        decor.zIndex = pivotAttributes.zIndex
                        result.append(decor)
                    }
                    if let decor = layoutAttributesForDecorationView(ofKind: WOTPivotSeparatorKind.bottom.rawValue, at: indexPath) as? WOTPivotSeparatorLayoutAttributes {
                        decor.customFrame = pivotAttributes.rect
                        decor.kind = .bottom
                        decor.zIndex = pivotAttributes.zIndex
                        result.append(decor)
                    }
                }
            }
        }
        return result
    }
}

extension WOTTankPivotLayout {

    fileprivate struct Constants {
        static let ipadCellSize = CGSize(width: 88.0, height: 66.0)
        static let iphoneCellSize = CGSize(width: 66.0, height: 44.0)
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

    fileprivate func relativeSize() -> CGSize {
        guard let block = self.relativeContentSizeBlock else {
            return .zero
        }
        return block()
    }

    fileprivate func pivotLayoutCellAttributes(indexPath: IndexPath, contentOffset: CGPoint) -> WOTPivotLayoutCellAttributesProtocol {
        let relativeRect = self.relativeRect(indexPath: indexPath)
        let stickyType = self.stickyType(indexPath: indexPath)
        let itemSize = self.itemSize

        var x: CGFloat = relativeRect.origin.x * CGFloat(itemSize.width)
        var y: CGFloat = relativeRect.origin.y * CGFloat(itemSize.height)

        let width: CGFloat = relativeRect.size.width * CGFloat(itemSize.width)
        let height: CGFloat = relativeRect.size.height * CGFloat(itemSize.height)

        var cellZIndex = -2
        if (stickyType.rawValue & PivotStickyType.vertical.rawValue) == PivotStickyType.vertical.rawValue {
            y += contentOffset.y
            cellZIndex += 1
        }
        if (stickyType.rawValue & PivotStickyType.horizontal.rawValue) == PivotStickyType.horizontal.rawValue {
            x += contentOffset.x
            cellZIndex += 1
        }
        let approxRect = CGRect(x: x, y: y, width: width, height: height)
        let cellRect = approxRect//.integral
        return WOTPivotLayoutCellAttributes(cellRect: cellRect, cellZIndex: cellZIndex, cellIndexPath: indexPath)
    }
}

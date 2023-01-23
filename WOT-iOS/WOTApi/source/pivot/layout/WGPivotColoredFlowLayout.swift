//
//  WGPivotColoredFlowLayout.swift
//  WOT-iOS
//
//  Created on 7/25/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - WOTTankPivotLayoutProtocol

@objc
public protocol WOTTankPivotLayoutProtocol {
    var relativeContentSizeBlock: (() -> CGSize)? { get set }
    var itemRelativeRectCallback: ((IndexPath) -> CGRect)? { get set }
    var itemLayoutStickyType: ((IndexPath) -> PivotStickyType)? { get set }
}

// MARK: - WGColoredFlowLayout

public class WGColoredFlowLayout: UICollectionViewFlowLayout {

    override public func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = WGPivotSeparatorCollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        layoutAttributes.color = UIColor.darkGray
        layoutAttributes.zIndex = -1
        return layoutAttributes
    }

    func layoutAttributesForDecorationView(ofKind elementKind: WOTPivotSeparatorKind, at indexPath: IndexPath, pivotAttributes: WGPivotLayoutCellAttributesProtocol) -> WGPivotSeparatorCollectionViewLayoutAttributes? {
        guard let layoutAttributes = layoutAttributesForDecorationView(ofKind: elementKind.rawValue, at: indexPath) as? WGPivotSeparatorCollectionViewLayoutAttributes else {
            return nil
        }
        layoutAttributes.kind = elementKind
        layoutAttributes.customFrame = pivotAttributes.rect
        layoutAttributes.zIndex = pivotAttributes.zIndex + 1
        return layoutAttributes
    }
}

// MARK: - WGPivotColoredFlowLayout

public class WGPivotColoredFlowLayout: WGColoredFlowLayout, WOTTankPivotLayoutProtocol {

    override open var itemSize: CGSize {
        get {
            return Constants.itemSize
        }
        set {}
    }

    override open var collectionViewContentSize: CGSize {
        get {
            let relativeSize = self.relativeSize()
            let itemSize = self.itemSize
            let width = relativeSize.width * itemSize.width
            let height = relativeSize.height * itemSize.height
            return CGSize(width: width, height: height)
        }
        set {}
    }

    override open func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath)
    }

    override open func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath)
    }

    override open func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()
        guard let collectionView = collectionView else {
            return result
        }

        for section in 0 ..< collectionView.numberOfSections {
            for row in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let separatorAttributes = sepatorAttributes(for: collectionView, at: indexPath, in: rect)
                result.append(contentsOf: separatorAttributes)
            }
        }
        return result
    }

    public var relativeContentSizeBlock: (() -> CGSize)?
    public var itemRelativeRectCallback: ((IndexPath) -> CGRect)?
    public var itemLayoutStickyType: ((IndexPath) -> PivotStickyType)?

    override public func prepare() {
        super.prepare()
        register(WGPivotSeparatorCollectionReusableView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.top.rawValue)
        register(WGPivotSeparatorCollectionReusableView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.left.rawValue)
        register(WGPivotSeparatorCollectionReusableView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.right.rawValue)
        register(WGPivotSeparatorCollectionReusableView.self, forDecorationViewOfKind: WOTPivotSeparatorKind.bottom.rawValue)
    }

    func sepatorAttributes(for collectionView: UICollectionView, at indexPath: IndexPath, in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        let contentOffset = collectionView.contentOffset
        let pivotAttributes = pivotLayoutCellAttributes(indexPath: indexPath, contentOffset: contentOffset)
        guard let cellAttributes = pivotAttributes.collectionViewLayoutAttributes(forRect: rect) else {
            return []
        }

        var result = [UICollectionViewLayoutAttributes?]()
        result.append(contentsOf: cellAttributes)
        result.append(layoutAttributesForDecorationView(ofKind: .right, at: indexPath, pivotAttributes: pivotAttributes))
        result.append(layoutAttributesForDecorationView(ofKind: .left, at: indexPath, pivotAttributes: pivotAttributes))
        result.append(layoutAttributesForDecorationView(ofKind: .top, at: indexPath, pivotAttributes: pivotAttributes))
        result.append(layoutAttributesForDecorationView(ofKind: .bottom, at: indexPath, pivotAttributes: pivotAttributes))

        return result.compactMap { $0 }
    }
}

private extension WGPivotColoredFlowLayout {
    struct Constants {
        static let ipadCellSize = CGSize(width: 88.0, height: 66.0)
        static let iphoneCellSize = CGSize(width: 66.0, height: 44.0)
        static let itemSize = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? ipadCellSize : iphoneCellSize
    }

    private func relativeRect(indexPath: IndexPath) -> CGRect {
        guard let block = itemRelativeRectCallback else {
            return CGRect.zero
        }
        return block(indexPath)
    }

    private func stickyType(indexPath: IndexPath) -> PivotStickyType {
        guard let block = itemLayoutStickyType else {
            return .float
        }
        return block(indexPath)
    }

    func relativeSize() -> CGSize {
        guard let block = relativeContentSizeBlock else {
            return .zero
        }
        return block()
    }

    func pivotLayoutCellAttributes(indexPath: IndexPath, contentOffset: CGPoint) -> WGPivotLayoutCellAttributesProtocol {
        let relativeRect = self.relativeRect(indexPath: indexPath)
        let stickyType = self.stickyType(indexPath: indexPath)
        let itemSize = self.itemSize

        var x: CGFloat = relativeRect.origin.x * CGFloat(itemSize.width)
        var y: CGFloat = relativeRect.origin.y * CGFloat(itemSize.height)

        let width: CGFloat = relativeRect.size.width * CGFloat(itemSize.width)
        let height: CGFloat = relativeRect.size.height * CGFloat(itemSize.height)

        var cellZIndex = -5
        if (stickyType.rawValue & PivotStickyType.vertical.rawValue) == PivotStickyType.vertical.rawValue {
            if contentOffset.y > 0 {
                y += contentOffset.y
            }
            cellZIndex += 2
        }
        if (stickyType.rawValue & PivotStickyType.horizontal.rawValue) == PivotStickyType.horizontal.rawValue {
            if contentOffset.x > 0 {
                x += contentOffset.x
            }
            cellZIndex += 2
        }
        let approxRect = CGRect(x: x, y: y, width: width, height: height)
        let cellRect = approxRect // .integral
        return WGPivotLayoutCellAttributes(cellRect: cellRect, cellZIndex: cellZIndex, cellIndexPath: indexPath)
    }
}

//
//  WOTTankConfigurationFlowLayout.swift
//  WOT-iOS
//
//  Created on 7/26/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - WOTTankConfigurationFlowLayoutProtocol

@objc
public protocol WOTTankConfigurationFlowLayoutProtocol: NSObjectProtocol {
    var depthCallback: (() -> Int)? { get set }
    var widthCallback: (() -> Int)? { get set }
    var layoutPreviousSiblingNodeChildrenCountCallback: ((IndexPath) -> (Int))? { get set }
}

// MARK: - WOTTankConfigurationFlowLayout

public class WOTTankConfigurationFlowLayout: UICollectionViewFlowLayout, WOTTankConfigurationFlowLayoutProtocol, WOTTankConfigurationFlowCellLayoutProtocol {

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
            let depth = relativeSize.width * itemSize.width
            let width = relativeSize.height * itemSize.height
            return CGSize(width: width, height: depth)
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
        return layoutAttributes(in: rect)
    }

    public var depthCallback: (() -> Int)?
    public var widthCallback: (() -> Int)?
    public var layoutPreviousSiblingNodeChildrenCountCallback: ((IndexPath) -> (Int))?
}

public extension WOTTankConfigurationFlowLayout {
    func layoutAttributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }

        var result = [UICollectionViewLayoutAttributes]()
        for section in 0 ..< collectionView.numberOfSections {
            for row in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let attr = layoutAttribute(indexPath: indexPath, rect: rect) {
                    result.append(attr)
                }
            }
        }
        return result
    }

    func layoutAttribute(indexPath: IndexPath, rect _: CGRect) -> UICollectionViewLayoutAttributes? {
        let cellFrame = self.cellFrame(indexPath: indexPath)
        #warning("check condition")
//        guard cellFrame.intersects(rect) else { return nil }
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = cellFrame
        return attrs
    }

    func cellFrame(indexPath: IndexPath) -> CGRect {
        let itemSize = self.itemSize
        let siblingChildrenCount = self.siblingChildrenCount(indexPath: indexPath)
        let x = itemSize.width * CGFloat(siblingChildrenCount)
        let y = itemSize.height * CGFloat(indexPath.section)
        return CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
    }
}

private extension WOTTankConfigurationFlowLayout {
    struct Constants {
        static let itemSize = CGSize(width: 44, height: 88)
    }

    func relativeSize() -> CGSize {
        let width = CGFloat(self.width())
        let depth = CGFloat(self.depth())
        return CGSize(width: width, height: depth)
    }

    func depth() -> Int {
        guard let block = depthCallback else {
            return 0
        }

        return block()
    }

    func width() -> Int {
        guard let block = widthCallback else {
            return 0
        }
        return block()
    }

    func siblingChildrenCount(indexPath: IndexPath) -> Int {
        guard let block = layoutPreviousSiblingNodeChildrenCountCallback else {
            return indexPath.row
        }
        return block(indexPath)
    }
}

/*
 see: https://goo.gl/zNUcS1

 Has parent    Has child    Has next sibling    Has prev sibling    Binary  Dec
 1    0           1           0                   0                   0100    4
 2    1           1           1                   0                   1110    14
 3    0           1           1                   1                   0111    7
 4    0           1           0                   1                   0101    5
 5    1           1           0                   0                   1100    12
 6    1           0           0                   0                   1000    8
 7    0           0           1                   1                   0011    3
 8    0           0           0                   0                   0000    0

 */

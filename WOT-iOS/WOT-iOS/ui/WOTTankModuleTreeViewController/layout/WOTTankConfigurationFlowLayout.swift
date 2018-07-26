//
//  WOTTankConfigurationFlowLayout.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/26/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTTankConfigurationFlowLayoutProtocol: NSObjectProtocol {
    var depthCallback: (() -> Int)? { get set }
    var widthCallback: (() -> Int)? { get set }
    var layoutPreviousSiblingNodeChildrenCountCallback: ((IndexPath) -> (Int))? { get set }
}

class WOTTankConfigurationFlowLayout: UICollectionViewFlowLayout, WOTTankConfigurationFlowLayoutProtocol {
    var depthCallback: (() -> Int)?
    var widthCallback: (() -> Int)?
    var layoutPreviousSiblingNodeChildrenCountCallback: ((IndexPath) -> (Int))?

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
            let depth = relativeSize.width * itemSize.width
            let width = relativeSize.height * itemSize.height
            return CGSize(width: width, height: depth)
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
        for section in 0 ..< collectionView.numberOfSections {
            for row in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let attrs = treeLayoutCellAttrubutes(indexPath: indexPath, rect: rect) {
                    result.append(attrs)
                }
            }
        }
        return result
    }
}

extension WOTTankConfigurationFlowLayout {

    fileprivate struct Constants {
        static let itemSize = CGSize(width: 44, height: 88)
    }

    fileprivate func relativeSize() -> CGSize {
        let width = CGFloat(self.width())
        let depth = CGFloat(self.depth())
        return CGSize(width: width, height: depth)
    }

    func depth() -> Int {
        guard let block = self.depthCallback else {
            return 0
        }

        return block()
    }

    func width() -> Int {
        guard let block = self.widthCallback else {
            return 0
        }
        return block()
    }

    private func siblingChildrenCount(indexPath: IndexPath) -> Int {
        guard let block = self.layoutPreviousSiblingNodeChildrenCountCallback else {
            return indexPath.row
        }
        return block(indexPath)
    }

    private func cellFrame(indexPath: IndexPath) -> CGRect {

        let itemSize = self.itemSize
        let siblingChildrenCount = self.siblingChildrenCount(indexPath: indexPath)
        let x = itemSize.width * CGFloat(siblingChildrenCount)
        let y = itemSize.height * CGFloat(indexPath.section)
        return CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)

    }

    private func treeLayoutCellAttrubutes(indexPath: IndexPath, rect: CGRect) -> UICollectionViewLayoutAttributes? {
        let cellFrame = self.cellFrame(indexPath: indexPath)
        if cellFrame.intersects(rect) {
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attrs.frame = cellFrame
            return attrs
        }
        return nil
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

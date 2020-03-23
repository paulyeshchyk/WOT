//
//  WOTPivotLayoutCellAttributes.swift
//  WOT-iOS
//
//  Created on 7/26/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

protocol WOTPivotLayoutCellAttributesProtocol {
    var rect: CGRect { get }
    var zIndex: Int { get }
    init(cellRect: CGRect, cellZIndex: Int, cellIndexPath: IndexPath)
    func collectionViewLayoutAttributes(forRect rect: CGRect) -> [UICollectionViewLayoutAttributes]?
}

struct WOTPivotLayoutCellAttributes: WOTPivotLayoutCellAttributesProtocol {
    var rect: CGRect
    var zIndex: Int
    var indexPath: IndexPath

    init(cellRect: CGRect, cellZIndex: Int, cellIndexPath: IndexPath) {
        rect = cellRect
        zIndex = cellZIndex
        indexPath = cellIndexPath
    }

    func collectionViewLayoutAttributes(forRect rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard self.rect.intersects(rect) == true else {
            return nil
        }
        let result = UICollectionViewLayoutAttributes(forCellWith: self.indexPath)
        result.frame = self.rect
        result.zIndex = self.zIndex
        return [result]
    }
}

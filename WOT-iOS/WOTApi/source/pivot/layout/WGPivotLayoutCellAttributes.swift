//
//  WGPivotLayoutCellAttributes.swift
//  WOT-iOS
//
//  Created on 7/26/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

protocol WGPivotLayoutCellAttributesProtocol {
    var rect: CGRect { get }
    var zIndex: Int { get }
    init(cellRect: CGRect, cellZIndex: Int, cellIndexPath: IndexPath)
    func collectionViewLayoutAttributes(forRect rect: CGRect) -> [UICollectionViewLayoutAttributes]?
}

struct WGPivotLayoutCellAttributes: WGPivotLayoutCellAttributesProtocol {
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
        let result = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        result.frame = self.rect
        result.zIndex = zIndex
        return [result]
    }
}

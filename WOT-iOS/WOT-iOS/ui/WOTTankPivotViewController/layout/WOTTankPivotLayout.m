//
//  WOTTankPivotLayout.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankPivotLayout.h"

#define DEFAULT_ITEM_SIZE_IPAD CGSizeMake(88.0f,66.0f)
#define DEFAULT_ITEM_SIZE_IPHONE CGSizeMake(66.0f,44.0f)

@implementation WOTTankPivotLayout

- (CGSize)itemSize {
    
    return IS_IPAD?DEFAULT_ITEM_SIZE_IPAD:DEFAULT_ITEM_SIZE_IPHONE;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* elementsInRect = [NSMutableArray array];
    
    CGPoint const contentOffset = self.collectionView.contentOffset;
    
    //iterate over all cells in this collection
    for(NSUInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        
        for(NSUInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {

            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];

            PivotLayoutCellAttributes *pivotLayoutCellAttributes = [self pivotLayoutCellAttributesWithIndexPath:indexPath contentOffset:contentOffset zIndex:0];
            UICollectionViewLayoutAttributes *attrs = [pivotLayoutCellAttributes collectionViewLayoutAttributesWithRect:rect indexPath:indexPath];
            if (attrs != nil) {
                [elementsInRect addObject:attrs];
            }
        }
    }
    
    return elementsInRect;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
}

@end

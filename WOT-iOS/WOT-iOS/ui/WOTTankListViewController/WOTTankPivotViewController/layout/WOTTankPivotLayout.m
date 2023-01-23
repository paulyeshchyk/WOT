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

- (CGSize)collectionViewContentSize {
    
    NSInteger depth = 0;
    NSInteger width = 0;
    if (self.relativeContentSizeBlock) {
        
        CGSize size = self.relativeContentSizeBlock();
        depth = size.height;
        width = size.width;
    }
    
    CGSize result = CGSizeMake(width * self.itemSize.width,depth * self.itemSize.height);
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    attributes.center = CGPointMake(indexPath.row * self.itemSize.width, indexPath.section * self.itemSize.height);
    return attributes;
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
            
            CGRect itemRelativeRect = CGRectZero;
            if (self.itemRelativeRectCallback) {
                
                itemRelativeRect = self.itemRelativeRectCallback([NSIndexPath indexPathForRow:row inSection:section]);
            }
            
            PivotStickyType stickyType = PivotStickyTypeFloat;
            if (self.itemLayoutStickyType) {
                
                stickyType = self.itemLayoutStickyType([NSIndexPath indexPathForRow:row inSection:section]);
            }
            
            NSInteger zIndex = 0;
            
            CGSize itemSize = self.itemSize;
            
            CGFloat x = itemRelativeRect.origin.x * itemSize.width;
            CGFloat y = itemRelativeRect.origin.y * itemSize.height;
            CGFloat width = itemRelativeRect.size.width * itemSize.width;
            CGFloat height = itemRelativeRect.size.height * itemSize.height;

            if ((stickyType & PivotStickyTypeVertical) == PivotStickyTypeVertical) {
                
                y += contentOffset.y;
                zIndex += 1;
            }
            if ((stickyType & PivotStickyTypeHorizontal) == PivotStickyTypeHorizontal) {
                
                x += contentOffset.x;
                zIndex += 1;
            }
            
            CGRect cellFrame = CGRectMake(x,
                                          y,
                                          width,
                                          height);
            
            //see if the collection view needs this cell
            if(CGRectIntersectsRect(cellFrame, rect)) {
                
                //create the attributes object
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
                attr.zIndex = zIndex;
                [elementsInRect addObject:attr];
            }
        }
    }
    
    return elementsInRect;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
}



@end

//
//  WOTTankDetailCollectionViewFlowLayout.m
//  WOT-iOS
//
//  Created on 6/29/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailCollectionViewFlowLayout.h"

@implementation WOTTankDetailCollectionViewFlowLayout

- (id)init {
    
    self = [super init];
    if (self){
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self){
        
        self.itemSize = IS_IPAD?CGSizeMake(768,44):CGSizeMake(320,44);
        self.headerReferenceSize =IS_IPAD?CGSizeMake(768,44):CGSizeMake(320,44);
        
    }
    return self;
}

/*
 * Sticky header
 * Author:toblerpwn
 * link:http://stackoverflow.com/a/13678922/973784
 */

/*
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *result = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in result) {
        
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in result) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [result addObject:layoutAttributes];
        
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in result) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            
            if (numberOfItemsInSection > 0) {
                
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            } else {
                
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:lastObjectIndexPath];
            }
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(
                           MAX(
                               contentOffset.y + cv.contentInset.top,
                               (CGRectGetMinY(firstObjectAttrs.frame) - headerHeight)
                               ),
                           (CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight)
                           );
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
            
        }
        
    }
    
    return result;
    
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
    
}
*/
@end

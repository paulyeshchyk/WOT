//
//  WOTTankPivotLayout.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankPivotLayout.h"

#define DEFAULT_ITEM_SIZE CGSizeMake(44.0f,88.0f)

@implementation WOTTankPivotLayout

- (CGSize)collectionViewContentSize {
    
    NSInteger depth = 0;
    if (self.depthCallback) {
        
        depth = self.depthCallback();
    }
    
    NSInteger width = 0;
    if (self.widthCallback) {
        
        width = self.widthCallback();
    }
    
    CGSize result = CGSizeMake(width * self.itemSize.width,depth * self.itemSize.height);
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defSize = DEFAULT_ITEM_SIZE;
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    attributes.center = CGPointMake(indexPath.row * defSize.width, indexPath.section * defSize.height);
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
    
    //iterate over all cells in this collection
    for(NSUInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        
        for(NSUInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            
            
            CGFloat x = row * self.itemSize.width;
            CGFloat y = section * self.itemSize.height;
            
//            if (self.layoutPreviousSiblingNodeChildrenCountCallback) {
//                
//                //used with lines
//                //NSInteger layoutSiblingChildrenCount = row;
//                NSInteger layoutSiblingChildrenCount = self.layoutPreviousSiblingNodeChildrenCountCallback([NSIndexPath indexPathForRow:row inSection:section]);
//                x = layoutSiblingChildrenCount * self.itemSize.width;
//            }
            
            //this is the cell at row j in section i
            CGRect cellFrame = CGRectMake(x,
                                          y,
                                          self.itemSize.width,
                                          self.itemSize.height);
            
            //see if the collection view needs this cell
            if(CGRectIntersectsRect(cellFrame, rect)) {
                
                //create the attributes object
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
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

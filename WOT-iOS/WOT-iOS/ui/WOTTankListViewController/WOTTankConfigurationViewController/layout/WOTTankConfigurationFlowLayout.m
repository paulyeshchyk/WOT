//
//  WOTTankConfigurationFlowLayout.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/30/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationFlowLayout.h"

#define DEFAULT_SIZE CGSizeMake(44.0f,44.0f)

@implementation WOTTankConfigurationFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
}

- (CGSize)itemSize {
    
    return DEFAULT_SIZE;
}

- (CGSize)collectionViewContentSize {

    NSInteger depth = 0;
    if (self.depthCallback) {
        
        depth = self.depthCallback();
    }
    
    NSInteger width = 0;
    if (self.widthCallback) {
        
        width = self.widthCallback();
    }
    
    return CGSizeMake(width * self.itemSize.width,depth * self.itemSize.height);
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defSize = DEFAULT_SIZE;
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    attributes.center = CGPointMake(indexPath.row * defSize.width, indexPath.section * defSize.height);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attributes;
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
 
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* elementsInRect = [NSMutableArray array];
    
    //iterate over all cells in this collection
    for(NSUInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        
        for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            
            
            CGFloat x = j*self.itemSize.width;
            CGFloat y = i*self.itemSize.height;
            
            if (self.layoutSiblingChildrenCountCallback) {
                
                NSInteger layoutSiblingChildrenCount = self.layoutSiblingChildrenCountCallback([NSIndexPath indexPathForRow:j inSection:i]);
                x = layoutSiblingChildrenCount * self.itemSize.width;
            }
            
            //this is the cell at row j in section i
            CGRect cellFrame = CGRectMake(x,
                                          y,
                                          self.itemSize.width,
                                          self.itemSize.height);
            
            //see if the collection view needs this cell
            if(CGRectIntersectsRect(cellFrame, rect)) {

                //create the attributes object
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
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

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
    if (self.depth) {
        
        depth = self.depth();
    }
    
    NSInteger width = 0;
    if (self.width) {
        
        width = self.width();
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

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
}

@end

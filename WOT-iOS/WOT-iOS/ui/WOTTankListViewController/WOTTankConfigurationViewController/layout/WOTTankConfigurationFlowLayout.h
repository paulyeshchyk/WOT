//
//  WOTTankConfigurationFlowLayout.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/30/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger(^LayoutDimensionBlock)(void);
typedef NSInteger(^LayoutSiblingChildrenCount)(NSIndexPath *);

@interface WOTTankConfigurationFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) LayoutDimensionBlock depthCallback;
@property (nonatomic, copy) LayoutDimensionBlock widthCallback;
@property (nonatomic, copy) LayoutSiblingChildrenCount layoutPreviousSiblingNodeChildrenCountCallback;

@end

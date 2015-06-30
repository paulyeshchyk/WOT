//
//  WOTTankConfigurationFlowLayout.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/30/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger(^LayoutDimensionBlock)(void);

@interface WOTTankConfigurationFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) LayoutDimensionBlock depth;
@property (nonatomic, copy) LayoutDimensionBlock width;

@end

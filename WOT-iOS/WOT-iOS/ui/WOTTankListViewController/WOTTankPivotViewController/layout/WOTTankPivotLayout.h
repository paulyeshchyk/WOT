//
//  WOTTankPivotLayout.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTTankPivotLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) LayoutRelativeContentSizeBlock relativeContentSizeBlock;
@property (nonatomic, copy) LayoutRelativeRectBlock itemRelativeRectCallback;
@property (nonatomic, copy) LayoutStickyType itemLayoutStickyType;

@end

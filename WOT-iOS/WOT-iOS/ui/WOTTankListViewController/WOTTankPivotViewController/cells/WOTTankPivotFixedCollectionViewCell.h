//
//  WOTTankPivotFixedCollectionViewCell.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTTankPivotFixedCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL hasBottomSeparator;
@property (nonatomic, assign) BOOL hasRightSeparator;
@property (nonatomic, strong) NSString *textValue;

@end

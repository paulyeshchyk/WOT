//
//  WOTTankPivotCollectionViewCell.h
//  WOT-iOS
//
//  Created on 6/30/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NodeBlock)(NSIndexPath *indexPath);

@interface WOTTankPivotDataCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, strong) UIColor *dataViewColor;

@property (nonatomic, assign) NSInteger uuid;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *dpm;
@property (nonatomic, copy) NSString *visibility;
@property (nonatomic, copy) NSString *mask;

@end

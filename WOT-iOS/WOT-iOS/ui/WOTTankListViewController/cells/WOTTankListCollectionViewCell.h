//
//  WOTTankListCollectionViewCell.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTTankListCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *tankType;
@property (nonatomic, copy) NSString *tankName;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger level;

@end

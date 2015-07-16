//
//  WOTTankConfigurationCollectionViewCell.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/30/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NodeBlock)(NSIndexPath *indexPath);

@interface WOTTankConfigurationCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy)NSIndexPath *indexPath;
@property (nonatomic,weak)IBOutlet UILabel *label;
@property (nonatomic,weak)IBOutlet UIImageView *imageView;

@end

//
//  WOTTankGridCollectionViewCell.h
//  WOT-iOS
//
//  Created on 9/14/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTTankGridCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)NSString *metricName;
@property (nonatomic, copy)NSArray *subitems;


+ (CGSize)sizeForSubitemsCount:(NSInteger)subitemsCount columnsCount:(NSInteger)rowsCount;
- (void)reloadCell;

@end

//
//  WOTTankListSettingSortTableViewCell.h
//  WOT-iOS
//
//  Created on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WOTTankListSettingSortTableViewCellSortClick)(BOOL ascending);

@interface WOTTankListSettingSortTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign)BOOL busy;
@property (nonatomic, assign)BOOL ascending;
@property (nonatomic, copy)WOTTankListSettingSortTableViewCellSortClick sortClick;
@property (nonatomic, assign)BOOL hasSorting;

@end

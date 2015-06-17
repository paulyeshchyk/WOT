//
//  WOTTankListSettingAddNewTableViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/11/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingAddNewTableViewCell.h"

@implementation WOTTankListSettingAddNewTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];

    UIView *selectedBackgoundView = [[UIView alloc] init];
    selectedBackgoundView.backgroundColor = [UIColor colorWithRed:37.0f/255.0f green:37.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
    self.selectedBackgroundView = selectedBackgoundView;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

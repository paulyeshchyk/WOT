//
//  WOTTankListCompoundViewTableViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingTableViewCell.h"
@interface WOTTankListSettingTableViewCell()

@property (nonatomic, weak)IBOutlet UILabel *keyLabel;
@property (nonatomic, weak)IBOutlet UILabel *valueLabel;

@end


@implementation WOTTankListSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *selectedBackgoundView = [[UIView alloc] init];
    selectedBackgoundView.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    self.selectedBackgroundView = selectedBackgoundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setSetting:(ListSetting *)setting {

    _setting = setting;
    [self.keyLabel setText:WOTString(setting.key)];
    [self.valueLabel setText:setting.values];
}


@end

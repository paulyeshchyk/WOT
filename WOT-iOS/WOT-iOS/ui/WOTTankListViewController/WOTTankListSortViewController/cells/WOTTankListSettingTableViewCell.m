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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (void)setSetting:(ListSetting *)setting {
//    _setting = setting;
//    [self.keyLabel setText:setting.key];
//    [self.valueLabel setText:setting.value];
//}

@end

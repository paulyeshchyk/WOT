//
//  WOTTankListCompoundViewTableViewCell.m
//  WOT-iOS
//
//  Created on 6/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingTableViewCell.h"
#import "NSBundle+LanguageBundle.h"

@interface WOTTankListSettingTableViewCell()

@property (nonatomic, weak)IBOutlet UILabel *keyLabel;
@property (nonatomic, weak)IBOutlet UILabel *valueLabel;

@end


@implementation WOTTankListSettingTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    UIView *selectedBackgoundView = [[UIView alloc] init];
    selectedBackgoundView.backgroundColor = [UIColor colorWithRed:37.0f/255.0f green:37.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
    self.selectedBackgroundView = selectedBackgoundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setSetting:(ListSetting *)setting {

    _setting = setting;
    [self.keyLabel setText:[NSString localization:setting.key]];
    [self.valueLabel setText:setting.values];
}


@end

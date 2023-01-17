//
//  WOTTankListSettingNameTableViewCell.m
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingNameTableViewCell.h"
#import "NSBundle+LanguageBundle.h"
#import <WOTApi/WOTApi-Swift.h>

@interface WOTTankListSettingNameTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *label;
@property (nonatomic, weak)IBOutlet UIImageView *markImageView;

@end

@implementation WOTTankListSettingNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    UIImage *image = selected?[UIImage imageNamed:[NSString localization: WOTApiImages.wotImageCheckmarkGray]]:nil;
    [self.markImageView setImage:image];
}

- (void)setText:(NSString *)text {

    _text = [text copy];
    [self.label setText:text];
}

@end

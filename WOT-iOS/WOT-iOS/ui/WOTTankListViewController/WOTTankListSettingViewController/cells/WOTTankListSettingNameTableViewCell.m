//
//  WOTTankListSettingNameTableViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingNameTableViewCell.h"

@interface WOTTankListSettingNameTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *label;
@property (nonatomic, weak)IBOutlet UIImageView *markImageView;

@end

@implementation WOTTankListSettingNameTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    UIImage *image = selected?[UIImage imageNamed:WOTString(WOT_IMAGE_CHECKMARK_GRAY)]:nil;
    [self.markImageView setImage:image];
}

- (void)setText:(NSString *)text {

    _text = [text copy];
    [self.label setText:text];
}

@end

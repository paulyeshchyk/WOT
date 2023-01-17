//
//  WOTTankListSettingSortTableViewCell.m
//  WOT-iOS
//
//  Created on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingSortTableViewCell.h"
#import <WOTApi/WOTApi-Swift.h>
#import "NSBundle+LanguageBundle.h"

@interface WOTTankListSettingSortTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *label;
@property (nonatomic, weak)IBOutlet UIImageView *markImageView;
@property (nonatomic, weak)IBOutlet UIButton *button;


@end

@implementation WOTTankListSettingSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ascending = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    UIImage *image = selected?[UIImage imageNamed:[NSString localization:WOTApiImages.wotImageCheckmarkGray]]:nil;
    [self.markImageView setImage:image];
    [self.button setHidden:(!selected || !self.hasSorting)];
}

- (void)setText:(NSString *)text {
    
    _text = [text copy];
    [self.label setText:text];
}

- (void)setAscending:(BOOL)ascending {
    
    _ascending = ascending;
    UIImage *image = ascending?[UIImage imageNamed:WOTApiImages.wotImageUp]:[UIImage imageNamed:WOTApiImages.wotImageDown];
    [self.button setImage:image forState:UIControlStateNormal];
}

- (IBAction)onSortClicked:(id)sender {

    if (self.sortClick) {
        
        self.sortClick(!self.ascending);
    }
}

@end

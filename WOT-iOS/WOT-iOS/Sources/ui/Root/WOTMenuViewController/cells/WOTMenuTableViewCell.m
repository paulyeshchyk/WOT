//
//  WOTMenuTableViewCell.m
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTMenuTableViewCell.h"

@interface WOTMenuTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak)IBOutlet UIImageView *cellImageView;
@property (nonatomic, weak)IBOutlet UIView *bottomSeparatorView;
@property (nonatomic, weak)IBOutlet UIView *customBackgroundView;

@end

@implementation WOTMenuTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.bottomSeparatorView.backgroundColor = WOT_COLOR_BOTTOM_CELL_SEPARATOR;
    self.customBackgroundView.backgroundColor = WOT_COLOR_CELL_BACKGROUND;
}

- (void)setCellImage:(UIImage *)cellImage {

    if ([cellImage isKindOfClass:[UIImage class]]) {

        [self.cellImageView setImage:cellImage];
    }
}

- (void)setCellTitle:(NSString *)cellTitle {
    
    if ([cellTitle isKindOfClass:[NSString class]]) {
        
        [self.cellTitleLabel setText:cellTitle];
    }
}

@end

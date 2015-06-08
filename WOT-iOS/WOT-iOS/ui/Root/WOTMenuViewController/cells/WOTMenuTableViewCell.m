//
//  WOTMenuTableViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMenuTableViewCell.h"

@interface WOTMenuTableViewCell ()

@property (nonatomic, weak)IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak)IBOutlet UIImageView *cellImageView;

@end

@implementation WOTMenuTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    UIView *selectedBackgroundView = [[UIView alloc] init];
//    [selectedBackgroundView setOpaque:NO];
//    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
//    [self setSelectedBackgroundView:selectedBackgroundView];
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

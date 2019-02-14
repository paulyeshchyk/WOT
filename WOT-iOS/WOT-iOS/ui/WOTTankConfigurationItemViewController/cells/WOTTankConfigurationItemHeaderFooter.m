//
//  WOTTankConfigurationItemHeaderFooter.m
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankConfigurationItemHeaderFooter.h"
@interface WOTTankConfigurationItemHeaderFooter()

@property (nonatomic, weak)IBOutlet UILabel *titleLabel;

@end

@implementation WOTTankConfigurationItemHeaderFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    self.titleLabel.text = title;
}

@end

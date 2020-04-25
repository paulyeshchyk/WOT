//
//  WOTTankConfigurationItemHeaderFooter.m
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankConfigurationItemHeaderFooter.h"
@interface WOTTankConfigurationItemHeaderFooter()

@property (nonatomic, weak)IBOutlet UILabel *titleLabel;

@end

@implementation WOTTankConfigurationItemHeaderFooter

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    self.titleLabel.text = title;
}

@end

//
//  WOTTankListSortHeaderView.m
//  WOT-iOS
//
//  Created on 6/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSortHeaderView.h"
#import "NSBundle+LanguageBundle.h"

@interface WOTTankListSortHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation WOTTankListSortHeaderView


- (void)setText:(NSString *)text {

    _text = [text copy];
    [self.label setText:[NSString localization:text]];
}

@end

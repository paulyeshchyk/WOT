//
//  WOTTankListSortHeaderView.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSortHeaderView.h"

@interface WOTTankListSortHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation WOTTankListSortHeaderView


- (void)setText:(NSString *)text {

    _text = [text copy];
    [self.label setText:WOTString(text)];
}

@end

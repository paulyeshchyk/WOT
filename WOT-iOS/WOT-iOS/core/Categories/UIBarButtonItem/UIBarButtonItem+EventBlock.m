//
//  UIBarButtonItem+EventBlock.m
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "UIBarButtonItem+EventBlock.h"

@implementation UIBarButtonItem (EventBlock)

+ (UIBarButtonItem *)barButtonItemForImage:(UIImage *)image text:(NSString *)text eventBlock:(EventHandlerBlock)eventBlock {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:(UIControlStateNormal)];
    [backButton setExclusiveTouch:YES];
    [backButton bk_addEventHandler:eventBlock forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:text forState:UIControlStateNormal];
    [backButton.titleLabel setLineBreakMode:(NSLineBreakByTruncatingTail)];
    [backButton sizeToFit];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backButtonItem;
}

@end

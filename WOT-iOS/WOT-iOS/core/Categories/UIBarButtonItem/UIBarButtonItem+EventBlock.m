//
//  UIBarButtonItem+EventBlock.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "UIBarButtonItem+EventBlock.h"

@implementation UIBarButtonItem (EventBlock)

+ (UIBarButtonItem *)barButtonItemForImage:(UIImage *)image text:(NSString *)text eventBlock:(EventHandlerBlock)eventBlock {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:(UIControlStateNormal)];
    [backButton setExclusiveTouch:YES];
    [backButton bk_addEventHandler:eventBlock forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:text forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backButtonItem;
}

@end

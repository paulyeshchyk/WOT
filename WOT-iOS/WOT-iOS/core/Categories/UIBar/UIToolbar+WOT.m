//
//  UIToolbar+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "UIToolbar+WOT.h"

@implementation UIToolbar (WOT)

- (void)setDarkStyle {
    
    [self setBarTintColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f]];
    
    UIColor *textColor = [UIColor lightGrayColor];
//    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               textColor,NSForegroundColorAttributeName,
//                                               nil];
    [self setTranslucent:NO];
//    [self setTitleTextAttributes:navbarTitleTextAttributes];
    [self setTintColor:textColor];
    [self setOpaque:YES];
    [self setBarStyle:UIBarStyleBlackTranslucent];
}

@end

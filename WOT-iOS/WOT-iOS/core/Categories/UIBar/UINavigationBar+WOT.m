//
//  UINavigationBar+WOT.m
//  WOT-iOS
//
//  Created on 6/5/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "UINavigationBar+WOT.h"

@implementation UINavigationBar (WOT)

- (void)setDarkStyle {
    
    [self setBarTintColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f]];
    
    UIColor *textColor = [UIColor lightGrayColor];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               textColor,NSForegroundColorAttributeName,
                                               nil];
    [self setTranslucent:NO];
    [self setTitleTextAttributes:navbarTitleTextAttributes];
    [self setTintColor:textColor];
    [self setOpaque:YES];
    [self setBarStyle:UIBarStyleBlackTranslucent];
}


@end

//
//  UIToolbar+WOT.m
//  WOT-iOS
//
//  Created on 6/29/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "UIToolbar+WOT.h"

@implementation UIToolbar (WOT)

- (void)setDarkStyle {
    
    [self setBarTintColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f]];
    
    [self setTranslucent:NO];
    [self setTintColor:[UIColor lightGrayColor]];
    [self setOpaque:YES];
    [self setBarStyle: UIBarStyleBlack];
}

@end

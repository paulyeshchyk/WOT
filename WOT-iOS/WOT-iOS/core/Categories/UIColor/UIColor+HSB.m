//
//  UIColor+HSB.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/24/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "UIColor+HSB.h"

@implementation UIColor (HSB)

- (UIColor *)lighterColor:(CGFloat)koeff
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * koeff, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor:(CGFloat)koeff {
    
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * koeff
                               alpha:a];
    return nil;
}


- (UIColor *)inverseColor {
    
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

- (UIColor *)paleColor {
    
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:0.6f
                          brightness:b
                               alpha:a];
    return nil;
}

- (UIColor *)inverseColorBW {
    
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    
    CGFloat darknessScore = 0;
    if (count == 2) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
    } else if (count == 4) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
    }
    
    if (darknessScore >= 125) {
        return [UIColor blackColor];
    }
    
    return [UIColor whiteColor];
}
@end

//
//  UIColor+HSB.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/24/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HSB)

- (UIColor *)lighterColor:(CGFloat)koeff;
- (UIColor *)darkerColor:(CGFloat)koeff;
- (UIColor *)inverseColor;
- (UIColor *)inverseColorBW;

@end

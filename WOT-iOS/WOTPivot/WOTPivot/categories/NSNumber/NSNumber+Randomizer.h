//
//  NSNumber+Randomizer.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSNumber (Randomizer)

+ (NSNumber *)randomValueForLow:(CGFloat)low_bound high:(CGFloat)high_bound;

@end

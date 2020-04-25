//
//  NSNumber+Randomizer.h
//  WOT-iOS
//
//  Created on 9/14/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSNumber (Randomizer)

+ (NSNumber *)randomValueForLow:(CGFloat)low_bound high:(CGFloat)high_bound;

@end

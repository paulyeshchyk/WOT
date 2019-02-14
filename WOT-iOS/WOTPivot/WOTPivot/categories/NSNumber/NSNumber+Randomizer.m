//
//  NSNumber+Randomizer.m
//  WOT-iOS
//
//  Created on 9/14/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "NSNumber+Randomizer.h"

@implementation NSNumber (Randomizer)

+ (NSNumber *)randomValueForLow:(CGFloat)low_bound high:(CGFloat)high_bound {
    
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    return @(rndValue);
}

@end

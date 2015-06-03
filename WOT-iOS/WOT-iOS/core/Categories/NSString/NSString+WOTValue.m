//
//  NSString+WOTValue.m
//  Horizon
//
//  Created by Pavel Yeshchyk on 7/24/14.
//  Copyright (c) 2014 EPAM Empathy Lab. All rights reserved.
//

#import "NSString+WOTValue.h"

@implementation NSString (WOTValue)

+ (NSString *)stringEmpty {
    
    return @"";
}

+ (NSString *)stringSpace {
    
    return @" ";
}
+ (NSString *)valueOrEmptyString:(NSString *)value {
    
    return value ? value : [NSString stringEmpty];
}

+ (NSString *)valueOrSpaceString:(NSString *)value {
    
    return value ? value : [NSString stringSpace];
}

+ (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacterSet:(NSString *)value {

    return ([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
    
}

@end

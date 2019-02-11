//
//  NSString+WOTValue.m
//  Horizon
//
//  Created by Pavel Yeshchyk on 6/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSString+WOTValue.h"

@implementation NSString (WOTValue)

+ (NSString *)valueOrSpaceString:(NSString *)value {
    
    return value ? value : @" ";
}

+ (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacterSet:(NSString *)value {

    return ([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
    
}

@end

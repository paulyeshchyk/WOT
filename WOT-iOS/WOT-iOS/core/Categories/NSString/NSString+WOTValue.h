//
//  NSString+WOTValue.h
//  Horizon
//
//  Created by Pavel Yeshchyk on 7/24/14.
//  Copyright (c) 2014 EPAM Empathy Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WOTValue)

+ (NSString *)stringEmpty;
+ (NSString *)valueOrEmptyString:(NSString *)value;
+ (NSString *)valueOrSpaceString:(NSString *)value;
+ (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacterSet:(NSString *)value;

@end

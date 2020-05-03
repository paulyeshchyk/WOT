//
//  NSString+WOTValue.h
//  Horizon
//
//  Created on 6/17/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WOTValue)

+ (NSString *)valueOrSpaceString:(NSString *)value;
+ (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacterSet:(NSString *)value;

@end

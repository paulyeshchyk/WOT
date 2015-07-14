//
//  NSArray+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSArray+WOT.h"

@implementation NSArray (WOT)

+ (BOOL)hasDataInArray:(NSArray *)array {

    if (![array isKindOfClass:[NSArray class]]) {
        
        return NO;
    }
    
    return ([array count] != 0);
    
}

@end

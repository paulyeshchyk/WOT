//
//  NSArray+WOT.m
//  WOT-iOS
//
//  Created on 7/14/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "NSArray+WOT.h"

@implementation NSArray (WOT)
@dynamic hasItems;

- (BOOL)hasItems {
    
    return ([self count] != 0);
}

@end

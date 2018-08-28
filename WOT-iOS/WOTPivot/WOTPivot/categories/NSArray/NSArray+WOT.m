//
//  NSArray+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSArray+WOT.h"

@implementation NSArray (WOT)
@dynamic hasItems;

- (BOOL)hasItems {
    
    return ([self count] != 0);
}

@end

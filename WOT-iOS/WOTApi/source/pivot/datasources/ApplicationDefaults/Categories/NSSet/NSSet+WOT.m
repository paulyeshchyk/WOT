//
//  NSSet+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSSet+WOT.h"

@implementation NSSet (WOT)
@dynamic hasItems;

- (BOOL)hasItems {
    
    return ([self count] != 0);
}


@end

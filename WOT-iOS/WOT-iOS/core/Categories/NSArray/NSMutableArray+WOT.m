//
//  NSMutableArray+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSMutableArray+WOT.h"

@implementation NSMutableArray (WOT)

- (void)clearNullValues {
    
    [self removeObject:[NSNull null]];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj respondsToSelector:@selector(clearNullValues)]) {
            
            [obj clearNullValues];
        }
    }];
}
@end

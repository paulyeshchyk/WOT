//
//  NSMutableDictionary+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSMutableDictionary+WOT.h"

@implementation NSMutableDictionary (WOT)

- (void)clearNullValues {
    
    [[self allKeys] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        
        id obj = self[key];
        if ([obj isKindOfClass:[NSNull class]]) {
            
            [self removeObjectForKey:key];
        } else {
            
            if ([obj respondsToSelector:@selector(clearNullValues)]) {

                [obj clearNullValues];
            }
        }
    }];
};

@end

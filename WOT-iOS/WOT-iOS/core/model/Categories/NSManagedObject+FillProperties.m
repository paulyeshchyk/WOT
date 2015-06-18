//
//  NSManagedObject+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSManagedObject+FillProperties.h"

@implementation NSManagedObject (FillProperties)

- (void)fillPropertiesFromDictioary:(NSDictionary *)jSON {

    NSCAssert(NO, @"should be overriden");
}

+ (NSArray *)availableFields {
    
    NSCAssert(NO, @"should be overriden");
    return nil;
}

@end

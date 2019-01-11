//
//  NSManagedObject+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSManagedObject+FillProperties.h"

@implementation NSManagedObject (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    NSString *exceptionText = [NSString stringWithFormat:@"should be overriden %@:%s",NSStringFromClass([self class]), __FUNCTION__];
    NSCAssert(NO, exceptionText);
}

+ (NSArray *)availableFields {
    
    NSString *exceptionText = [NSString stringWithFormat:@"should be overriden %@:%s",NSStringFromClass([self class]), __FUNCTION__];
    NSCAssert(NO, exceptionText);
    return nil;
}

+ (NSArray *)availableLinks {
    
    NSString *exceptionText = [NSString stringWithFormat:@"should be overriden %@:%s",NSStringFromClass([self class]), __FUNCTION__];
    NSCAssert(NO, exceptionText);
    return nil;
}

+ (NSArray *)embeddedLinks {
    
    NSString *exceptionText = [NSString stringWithFormat:@"should be overriden %@:%s",NSStringFromClass([self class]), __FUNCTION__];
    NSCAssert(NO, exceptionText);
    return nil;
}

@end
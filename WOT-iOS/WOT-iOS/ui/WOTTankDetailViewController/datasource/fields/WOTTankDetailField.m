//
//  WOTTankDetailField.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailField.h"



@implementation WOTTankDetailField

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath{
    
    return [self fieldWithFieldPath:fieldPath query:nil fieldDescription:nil];
}

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query {
    
    return [self fieldWithFieldPath:fieldPath query:query fieldDescription:nil];
}

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query fieldDescription:(NSString *)fieldDescription {
    
    WOTTankDetailField *result = [[self alloc] init];
    result.fieldPath = fieldPath;
    result.query = query;
    result.fieldDescriotion = fieldDescription;
    return result;
}


- (id)evaluateWithObject:(id)object {
    
    NSCAssert(NO, @"should be overriden");
    return nil;
}
@end
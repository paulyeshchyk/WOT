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
    
    return [self fieldWithFieldPath:fieldPath fieldDescription:nil];
}

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath fieldDescription:(NSString *)fieldDescription {
    
    WOTTankDetailField *result = [[WOTTankDetailField alloc] init];
    result.fieldPath = fieldPath;
    result.fieldDescriotion = fieldDescription;
    return result;
}

@end
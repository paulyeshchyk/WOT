//
//  NSExpressionDescription+WOT.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSExpressionDescription+WOT.h"

const NSString * WOTTankDetailFieldExpressionUsedForSingleObject = @"usedForSingleObject";

@implementation NSExpressionDescription (WOT)

+ (NSExpressionDescription *)valueExpressionDescriptionForField:(NSString *)field {
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.expression = [NSExpression expressionForKeyPath:field];
    expressionDescription.expressionResultType = NSInteger64AttributeType;
    expressionDescription.name = @"this";
    expressionDescription.userInfo = @{WOTTankDetailFieldExpressionUsedForSingleObject:@(YES)};
    return expressionDescription;
}

+ (NSExpressionDescription *)maxExpressionDescriptionForField:(NSString *)field {
    
    NSExpression *path = [NSExpression expressionForKeyPath:field];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.expression = [NSExpression expressionForFunction:@"max:" arguments:@[path]];
    expressionDescription.expressionResultType = NSInteger64AttributeType;
    expressionDescription.name = @"max";
    return expressionDescription;
}

+ (NSExpressionDescription *)averageExpressionDescriptionForField:(NSString *)field {
    
    NSExpression *path = [NSExpression expressionForKeyPath:field];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.expression = [NSExpression expressionForFunction:@"average:" arguments:@[path]];
    expressionDescription.expressionResultType = NSInteger64AttributeType;
    expressionDescription.name = @"av";
    return expressionDescription;
}


@end

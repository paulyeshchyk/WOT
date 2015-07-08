//
//  WOTTankDetailFieldExpression+Factory.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpression+Factory.h"

@implementation WOTTankDetailFieldExpression (Factory)

+ (WOTTankDetailFieldExpression *)avarageThisMaxFieldExpressionForField:(NSString *)field {
    
    NSExpression *path = [NSExpression expressionForKeyPath:field];
    
    NSExpression *averageExpression = [NSExpression expressionForFunction:@"average:" arguments:@[path]];
    NSExpressionDescription *averageDescription = [[NSExpressionDescription alloc] init];
    averageDescription.expression = averageExpression;
    averageDescription.expressionResultType = NSInteger64AttributeType;
    averageDescription.name = @"av";

    NSExpressionDescription *thisDescription = [[NSExpressionDescription alloc] init];
    thisDescription.expression = [NSExpression expressionForKeyPath:field];
    thisDescription.expressionResultType = NSInteger64AttributeType;
    thisDescription.name = @"this";
    thisDescription.userInfo = @{WOTTankDetailFieldExpressionUsedForSingleObject:@(YES)};

    
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[path]];
    NSExpressionDescription *maxDescription = [[NSExpressionDescription alloc] init];
    maxDescription.expression = maxExpression;
    maxDescription.expressionResultType = NSInteger64AttributeType;
    maxDescription.name = @"max";

    
    WOTTankDetailFieldExpression *result = [WOTTankDetailFieldExpression expressionName:field fieldWithExpressionDescriptions:@[averageDescription,thisDescription,maxDescription] keyPaths:@[averageDescription.name,thisDescription.name,maxDescription.name]];
    return result;
    
}

@end

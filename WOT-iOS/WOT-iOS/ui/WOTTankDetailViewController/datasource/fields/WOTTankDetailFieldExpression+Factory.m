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

    NSExpressionDescription *description = [[NSExpressionDescription alloc] init];
    description.expression = [NSExpression expressionForKeyPath:field];
    description.expressionResultType = NSInteger64AttributeType;
    description.name = @"this";

    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[path]];
    NSExpressionDescription *maxDescription = [[NSExpressionDescription alloc] init];
    maxDescription.expression = maxExpression;
    maxDescription.expressionResultType = NSInteger64AttributeType;
    maxDescription.name = @"max";
    
    
    WOTTankDetailFieldExpression *result = [WOTTankDetailFieldExpression fieldWithExpressionDescriptions:@[averageDescription,description,maxDescription] keyPaths:@[averageDescription.name,description.name,maxDescription.name]];
    return result;
    
}

@end

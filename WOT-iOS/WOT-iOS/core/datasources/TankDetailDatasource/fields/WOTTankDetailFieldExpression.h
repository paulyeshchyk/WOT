//
//  WOTTankDetailFieldExpression.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailField.h"
#import "NSExpressionDescription+WOT.h"

@interface WOTTankDetailFieldExpression : WOTTankDetailField

@property (nonatomic, strong)NSArray *expressionDescriptions;
@property (nonatomic, strong)NSArray *keyPaths;

+ (WOTTankDetailFieldExpression *)expressionName:(NSString *)expressionName fieldWithExpressionDescriptions:(NSArray *)expressionDescriptions  keyPaths:(NSArray *)keyPaths;

- (NSPredicate *)predicateForAllPlayingVehiclesWithObject:(id)object;
- (NSPredicate *)predicateForAnyObject:(NSArray *)objects;

@end

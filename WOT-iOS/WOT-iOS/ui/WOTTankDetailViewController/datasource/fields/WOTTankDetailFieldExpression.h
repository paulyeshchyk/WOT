//
//  WOTTankDetailFieldExpression.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailField.h"

extern NSString * WOTTankDetailFieldExpressionUsedForSingleObject;

@interface WOTTankDetailFieldExpression : WOTTankDetailField

- (NSPredicate *)predicateForObject:(id)object;

+ (WOTTankDetailFieldExpression *)expressionName:(NSString *)expressionName fieldWithExpressionDescriptions:(NSArray *)expressionDescriptions  keyPaths:(NSArray *)keyPaths;



@end

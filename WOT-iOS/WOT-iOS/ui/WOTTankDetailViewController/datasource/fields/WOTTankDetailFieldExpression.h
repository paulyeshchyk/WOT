//
//  WOTTankDetailFieldExpression.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/7/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailField.h"

@interface WOTTankDetailFieldExpression : WOTTankDetailField

+ (WOTTankDetailFieldExpression *)fieldWithExpressionDescriptions:(NSArray *)expressionDescriptions  keyPaths:(NSArray *)keyPaths;

@end

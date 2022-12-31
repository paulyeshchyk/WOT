//
//  WOTEnginePowerCompareFieldExpression.m
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTEnginePowerCompareFieldExpression.h"
#import "WOTTankIdsDatasource.h"
#import <WOTApi/WOTApi-Swift.h>

@implementation WOTEnginePowerCompareFieldExpression

- (id)init {
    
    self = [super init];
    if (self){
        
        NSExpressionDescription *averageExpressionDescription = [NSExpressionDescription averageExpressionDescriptionForField:WOTApiFields.power];
        NSExpressionDescription *maxExpressionDescription = [NSExpressionDescription maxExpressionDescriptionForField:WOTApiFields.power];
        NSExpressionDescription *valueExpressionDescription = [NSExpressionDescription valueExpressionDescriptionForField:WOTApiFields.power];
        
        
        self.expressionDescriptions = @[averageExpressionDescription,valueExpressionDescription,maxExpressionDescription];
        self.keyPaths = @[averageExpressionDescription.name,valueExpressionDescription.name,maxExpressionDescription.name];
        self.expressionName = WOTApiFields.power;
        
    }
    return self;
}

- (NSPredicate *)predicateForAllPlayingVehiclesWithObject:(id)object {
    
    id level = [[object valueForKeyPath:@"vehicles.tier"] allObjects];
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:level];
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tier, $m, ANY $m.tier IN %@).@count > 0",tiers];
}


@end

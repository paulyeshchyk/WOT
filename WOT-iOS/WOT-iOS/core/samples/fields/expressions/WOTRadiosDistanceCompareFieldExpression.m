//
//  WOTRadiosDistanceCompareFieldExpression.m
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRadiosDistanceCompareFieldExpression.h"
#import "WOTTankIdsDatasource.h"

@implementation WOTRadiosDistanceCompareFieldExpression

- (id)init {
    
    self = [super init];
    if (self){
        
        NSExpressionDescription *averageExpressionDescription = [NSExpressionDescription averageExpressionDescriptionForField:WOTApiKeys.distance];
        NSExpressionDescription *maxExpressionDescription = [NSExpressionDescription maxExpressionDescriptionForField:WOTApiKeys.distance];
        NSExpressionDescription *valueExpressionDescription = [NSExpressionDescription valueExpressionDescriptionForField:WOTApiKeys.distance];
        
        
        self.expressionDescriptions = @[averageExpressionDescription,valueExpressionDescription,maxExpressionDescription];
        self.keyPaths = @[averageExpressionDescription.name,valueExpressionDescription.name,maxExpressionDescription.name];
        self.expressionName = WOTApiKeys.distance;
        
    }
    return self;
}

- (NSPredicate *)predicateForAllPlayingVehiclesWithObject:(id)object {
    
    id level = [[object valueForKeyPath:@"vehicles.tier"] allObjects];
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:level];
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tier, $m, ANY $m.tier IN %@).@count > 0",tiers];
}

@end

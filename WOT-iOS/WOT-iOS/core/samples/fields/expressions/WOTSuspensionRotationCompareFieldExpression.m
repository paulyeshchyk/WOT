//
//  WOTSuspensionRotationCompareFieldExpression.m
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTSuspensionRotationCompareFieldExpression.h"
#import "WOTTankIdsDatasource.h"

@implementation WOTSuspensionRotationCompareFieldExpression

- (id)init {
    
    self = [super init];
    if (self){
        
        NSExpressionDescription *averageExpressionDescription = [NSExpressionDescription averageExpressionDescriptionForField:WOTApiKeys.rotation_speed];
        NSExpressionDescription *maxExpressionDescription = [NSExpressionDescription maxExpressionDescriptionForField:WOTApiKeys.rotation_speed];
        NSExpressionDescription *valueExpressionDescription = [NSExpressionDescription valueExpressionDescriptionForField:WOTApiKeys.rotation_speed];
        
        
        self.expressionDescriptions = @[averageExpressionDescription,valueExpressionDescription,maxExpressionDescription];
        self.keyPaths = @[averageExpressionDescription.name,valueExpressionDescription.name,maxExpressionDescription.name];
        self.expressionName = WOTApiKeys.rotation_speed;
        
    }
    return self;
}

- (NSPredicate *)predicateForAllPlayingVehiclesWithObject:(id)object {
    
    id level = [[object valueForKeyPath:@"vehicles.tier"] allObjects];
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:level];
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tier, $m, ANY $m.tier IN %@).@count > 0",tiers];
}

- (NSPredicate *)predicateForAnyObject:(NSArray *)objects {
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tank_id, $m, ANY $m.tank_id IN %@).@count > 0",objects];
}

@end

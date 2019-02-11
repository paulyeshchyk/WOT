//
//  WOTGunRateCompareFieldExpression.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTGunRateCompareFieldExpression.h"
#import "WOTTankIdsDatasource.h"

@implementation WOTGunRateCompareFieldExpression

- (id)init {
    
    self = [super init];
    if (self){

        NSExpressionDescription *averageExpressionDescription = [NSExpressionDescription averageExpressionDescriptionForField:WOTApiKeys.rate];
        NSExpressionDescription *maxExpressionDescription = [NSExpressionDescription maxExpressionDescriptionForField:WOTApiKeys.rate];
        NSExpressionDescription *valueExpressionDescription = [NSExpressionDescription valueExpressionDescriptionForField:WOTApiKeys.rate];
        
        
        self.expressionDescriptions = @[averageExpressionDescription,valueExpressionDescription,maxExpressionDescription];
        self.keyPaths = @[averageExpressionDescription.name,valueExpressionDescription.name,maxExpressionDescription.name];
        self.expressionName = WOTApiKeys.rate;

    }
    return self;
}

- (NSPredicate *)predicateForAllPlayingVehiclesWithObject:(id)object {
    
    id level = [[object valueForKeyPath:@"vehicles.tier"] allObjects];
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:level];
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tier, $m, ANY $m.tier IN %@).@count > 0",tiers];
}

@end

//
//  WOTTurretsArmorBoardCompareFieldExpression.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTurretsArmorBoardCompareFieldExpression.h"
#import "WOTTankIdsDatasource.h"

@implementation WOTTurretsArmorBoardCompareFieldExpression

- (id)init {
    
    self = [super init];
    if (self){
        
        NSExpressionDescription *averageExpressionDescription = [NSExpressionDescription averageExpressionDescriptionForField:WOTApiKeys.armor_board];
        NSExpressionDescription *maxExpressionDescription = [NSExpressionDescription maxExpressionDescriptionForField:WOTApiKeys.armor_board];
        NSExpressionDescription *valueExpressionDescription = [NSExpressionDescription valueExpressionDescriptionForField:WOTApiKeys.armor_board];
        
        
        self.expressionDescriptions = @[averageExpressionDescription,valueExpressionDescription,maxExpressionDescription];
        self.keyPaths = @[averageExpressionDescription.name,valueExpressionDescription.name,maxExpressionDescription.name];
        self.expressionName = WOTApiKeys.armor_board;
        
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

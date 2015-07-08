//
//  WOTTankDetailFieldExpressionGuns.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailFieldExpressionGuns.h"
#import "WOTTankIdsDatasource.h"

@implementation WOTTankDetailFieldExpressionGuns

- (NSPredicate *)predicateForObject:(id)object {
    
    id level = [[object valueForKeyPath:@"vehicles.tier"] allObjects];
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:level];
    
    return [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tier, $m, ANY $m.tier IN %@).@count > 0",tiers];
}

@end

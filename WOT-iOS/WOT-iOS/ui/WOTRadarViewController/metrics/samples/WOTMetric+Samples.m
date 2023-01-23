//
//  WOTMetric+Samples.m
//  WOT-iOS
//
//  Created by Paul on 7/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMetric+Samples.h"
#import "WOTCoreDataProvider.h"
#import "Tankengines.h"
#import "Tankturrets.h"
#import "WOTTankDetailFieldExpression+Factory.h"

@implementation WOTMetric (Samples)

+ (id<WOTTankMetricProtocol>)circularVisionCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_CIRCULAR_VISION_RADIUS) evaluator:^float(WOTTanksIDList *tankID) {
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tank_id, $m, ANY $m.tank_id IN %@).@count > 0",allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return NAN;
        } else {
            
            float thisValue = [[result lastObject][@"this"] floatValue];
//            float maxValue = [[result lastObject][@"max"] floatValue];
//            float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue * 100.0f);
            return thisValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)armorBoardCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_BOARD) evaluator:^float(WOTTanksIDList *tankID) {

        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tank_id, $m, ANY $m.tank_id IN %@).@count > 0",allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return NAN;
        } else {
            
            float thisValue = [[result lastObject][@"this"] floatValue];
//            float maxValue = [[result lastObject][@"max"] floatValue];
//            float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue * 100.0f);
            return thisValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)armorFeddCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_FEDD) evaluator:^float(WOTTanksIDList *tankID) {
        
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tank_id, $m, ANY $m.tank_id IN %@).@count > 0",allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return NAN;
        } else {
            
            float thisValue = [[result lastObject][@"this"] floatValue];
//            float maxValue = [[result lastObject][@"max"] floatValue];
//            float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue * 100.0f);
            return thisValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)armorForeheadCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_FOREHEAD) evaluator:^float(WOTTanksIDList *tankID) {
        
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tank_id, $m, ANY $m.tank_id IN %@).@count > 0",allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        if ([result count] == 0) {
            
            return NAN;
        } else {
            
            float thisValue = [[result lastObject][@"this"] floatValue];
//            float maxValue = [[result lastObject][@"max"] floatValue];
//            float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue * 100.0f);
            return thisValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)fireStartingChanceCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_FIRE_STARTING_CHANCE) evaluator:^float(WOTTanksIDList *tankID) {
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(vehicles.tank_id, $m, ANY $m.tank_id IN %@).@count > 0",allids];
        
        id expr = [WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankengines class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return NAN;
        } else {
            
            float thisValue = [[result lastObject][@"this"] floatValue];
//            float maxValue = [[result lastObject][@"max"] floatValue];
//            float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue * 100.0f);
            return thisValue;
        }
    }];
}


+ (NSArray *)metricsForOption:(WOTTankMetricOptions) option {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionArmor]) {
        
        [result addObject:[WOTMetric armorBoardCompareMetric]];
        [result addObject:[WOTMetric armorFeddCompareMetric]];
        [result addObject:[WOTMetric armorForeheadCompareMetric]];
    }
    
    if ([WOTMetric options:option includesOption:WOTTankDetailPropertySelectionFire]) {
        
        [result addObject:[WOTMetric fireStartingChanceCompareMetric]];
    }
    
    if ([WOTMetric options:option includesOption:WOTTankDetailPropertySelectionObserve]) {
        
        [result addObject:[WOTMetric circularVisionCompareMetric]];
    }
    return result;
}


+ (BOOL)options:(WOTTankMetricOptions)sourceOption includesOption:(WOTTankMetricOptions)option {
    
    return ((sourceOption & option) == option);
}

+ (WOTTankMetricOptions)options:(WOTTankMetricOptions)options invertOption:(WOTTankMetricOptions)option {
    
    if ([WOTMetric options:options includesOption:option]) {
        
        return options &= ~option;
    } else {
        
        return options |= option;
    }
}

@end

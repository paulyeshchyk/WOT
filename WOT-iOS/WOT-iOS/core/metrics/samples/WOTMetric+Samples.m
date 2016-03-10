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
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_CIRCULAR_VISION_RADIUS) grouppingName:WOTString(WOT_STRING_OBSERVE)  evaluator:^WOTTankEvalutionResult*(WOTTanksIDList *tankID) {
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression];
        NSPredicate *predicate = [expr predicateForAnyObject:allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return nil;
        } else {
            
            WOTTankEvalutionResult *returningValue = [[WOTTankEvalutionResult alloc] init];
            returningValue.thisValue = [[result lastObject][@"this"] floatValue];

            return returningValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)armorBoardCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_BOARD) grouppingName:WOTString(WOT_STRING_ARMOR) evaluator:^WOTTankEvalutionResult*(WOTTanksIDList *tankID) {

        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression];
        NSPredicate *predicate = [expr predicateForAnyObject:allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return nil;
        } else {
            
            WOTTankEvalutionResult *returningValue = [[WOTTankEvalutionResult alloc] init];
            returningValue.thisValue = [[result lastObject][@"this"] floatValue];
            returningValue.maxValue = [[result lastObject][@"max"] floatValue];
            returningValue.averageValue = [[result lastObject][@"av"] floatValue];
            return returningValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)armorFeddCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_FEDD) grouppingName:WOTString(WOT_STRING_ARMOR)  evaluator:^WOTTankEvalutionResult*(WOTTanksIDList *tankID) {
        
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression];
        NSPredicate *predicate = [expr predicateForAnyObject:allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return nil;
        } else {
            
            WOTTankEvalutionResult *returningValue = [[WOTTankEvalutionResult alloc] init];
            returningValue.thisValue = [[result lastObject][@"this"] floatValue];
            returningValue.maxValue = [[result lastObject][@"max"] floatValue];
            returningValue.averageValue = [[result lastObject][@"av"] floatValue];
            return returningValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)armorForeheadCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_FOREHEAD) grouppingName:WOTString(WOT_STRING_ARMOR)  evaluator:^WOTTankEvalutionResult*(WOTTanksIDList *tankID) {
        
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression];
        NSPredicate *predicate = [expr predicateForAnyObject:allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankturrets class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        if ([result count] == 0) {
            
            return NULL;
        } else {
            
            WOTTankEvalutionResult *returningValue = [[WOTTankEvalutionResult alloc] init];
            returningValue.thisValue = [[result lastObject][@"this"] floatValue];
            returningValue.maxValue = [[result lastObject][@"max"] floatValue];
            returningValue.averageValue = [[result lastObject][@"av"] floatValue];
            return returningValue;
        }
    }];
}

+ (id<WOTTankMetricProtocol>)fireStartingChanceCompareMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_FIRE_STARTING_CHANCE) grouppingName:WOTString(WOT_STRING_FIRE) evaluator:^WOTTankEvalutionResult*(WOTTanksIDList *tankID) {
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        WOTTankDetailFieldExpression *expr = [WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression];
        NSPredicate *predicate = [expr predicateForAnyObject:allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tankengines class])];
        request.predicate = predicate;
        request.propertiesToFetch = [expr expressionDescriptions];
        request.resultType = NSDictionaryResultType;
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        id result = [context executeFetchRequest:request error:&error];
        
        if ([result count] == 0) {
            
            return NULL;
        } else {
            
            WOTTankEvalutionResult *returningValue = [[WOTTankEvalutionResult alloc] init];
            returningValue.thisValue = [[result lastObject][@"this"] floatValue];
            returningValue.maxValue = [[result lastObject][@"max"] floatValue];
            returningValue.averageValue = [[result lastObject][@"av"] floatValue];
            return returningValue;
        }
    }];
}


+ (NSArray *)metricsForOptions:(WOTTankMetricOptions) option {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionsArmo]) {
        
        [result addObject:[WOTMetric armorBoardCompareMetric]];
        [result addObject:[WOTMetric armorFeddCompareMetric]];
        [result addObject:[WOTMetric armorForeheadCompareMetric]];
    }
    
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionsFire]) {
        
        [result addObject:[WOTMetric fireStartingChanceCompareMetric]];
    }
    
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionsObse]) {
        
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

//
//  WOTMetric+Samples.m
//  WOT-iOS
//
//  Created by Paul on 7/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMetric+Samples.h"
#import "WOTCoreDataProvider.h"
#import "Tankchassis.h"
#import "Tankengines.h"
#import "Tankturrets.h"
#import "WOTTankDetailFieldExpression+Factory.h"

@implementation WOTMetric (Samples)

+ (id<WOTTankMetricProtocol>)standardCompareMetricForClass:(Class)clazz byExpression:(WOTTankDetailFieldExpression *)expression withName:(NSString *)name groupName:(NSString *)groupName {
    
    return [[WOTMetric alloc] initWithMetricName:name grouppingName:groupName evaluator:^WOTTankEvalutionResult*(WOTTanksIDList *tankID) {
        
        NSError *error = nil;
        NSArray *allids = [tankID allObjects];
        
        NSPredicate *predicate = [expression predicateForAnyObject:allids];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(clazz)];
        request.predicate = predicate;
        request.propertiesToFetch = [expression expressionDescriptions];
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

+ (id<WOTTankMetricProtocol>)suspensionRotationSpeedCompareMetric {
    
    return [self standardCompareMetricForClass:[Tankchassis class]
                                  byExpression:[WOTTankDetailFieldExpression suspensionRotationSpeedCompareFieldExpression]
                                      withName:WOTString(WOT_KEY_ROTATION_SPEED)
                                     groupName:WOTString(WOT_STRING_MOBI)];
}

+ (id<WOTTankMetricProtocol>)fireStartingChanceCompareMetric {
    
    return [self standardCompareMetricForClass:[Tankengines class]
                                  byExpression:[WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression]
                                      withName:WOTString(WOT_KEY_FIRE_STARTING_CHANCE)
                                     groupName:WOTString(WOT_STRING_MOBI)];
}

+ (id<WOTTankMetricProtocol>)circularVisionCompareMetric {
    
    return [self standardCompareMetricForClass:[Tankturrets class]
                                  byExpression:[WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression]
                                      withName:WOTString(WOT_KEY_CIRCULAR_VISION_RADIUS)
                                     groupName:WOTString(WOT_STRING_OBSERVE)];

}

+ (id<WOTTankMetricProtocol>)armorBoardCompareMetric {
    
    return [self standardCompareMetricForClass:[Tankturrets class]
                                  byExpression:[WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression]
                                      withName:WOTString(WOT_KEY_ARMOR_BOARD)
                                     groupName:WOTString(WOT_STRING_ARMOR)];
}

+ (id<WOTTankMetricProtocol>)armorFeddCompareMetric {

    return [self standardCompareMetricForClass:[Tankturrets class]
                                  byExpression:[WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression]
                                      withName:WOTString(WOT_KEY_ARMOR_FEDD)
                                     groupName:WOTString(WOT_STRING_ARMOR)];
}

+ (id<WOTTankMetricProtocol>)armorForeheadCompareMetric {
    
    
    return [self standardCompareMetricForClass:[Tankturrets class]
                                  byExpression:[WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression]
                                      withName:WOTString(WOT_KEY_ARMOR_FOREHEAD)
                                     groupName:WOTString(WOT_STRING_ARMOR)];
}

+ (NSArray *)metricsForOptions:(WOTTankMetricOptions) option {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionsArmor]) {
        
        [result addObject:[WOTMetric armorBoardCompareMetric]];
        [result addObject:[WOTMetric armorFeddCompareMetric]];
        [result addObject:[WOTMetric armorForeheadCompareMetric]];
    }
    
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionsMobility]) {
        
        [result addObject:[WOTMetric fireStartingChanceCompareMetric]];
        [result addObject:[WOTMetric suspensionRotationSpeedCompareMetric]];
    }
    
    if ([WOTMetric options:option includesOption:WOTTankMetricOptionsObserve]) {
        
        [result addObject:[WOTMetric circularVisionCompareMetric]];
    }
    return result;
}

@end

//
//  WOTMetric+Samples.m
//  WOT-iOS
//
//  Created on 7/28/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTMetric+Samples.h"
#import <WOTData/WOTData.h>
#import "WOTTankDetailFieldExpression+Factory.h"
#import <WOTPivot/WOTPivot.h>

@interface StandardCompareMetricEvaluator: NSObject<WOTTankMetricEvaluatorProtocol>
@property (nonatomic, strong) WOTTankDetailFieldExpression* expression;
@property (nonatomic, assign) Class clazz;
@end

@implementation StandardCompareMetricEvaluator

- (id<WOTTankEvaluationResultProtocol>) evaluateWithList:(id<WOTTanksIDListProtocol>)list {
    NSError *error = nil;
    NSArray *allids = [list allObjects];
    
    NSPredicate *predicate = [self.expression predicateForAnyObject:allids];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.clazz)];
    request.predicate = predicate;
    request.propertiesToFetch = [self.expression expressionDescriptions];
    request.resultType = NSDictionaryResultType;
    id<WOTCoredataProviderProtocol> dataProvider = [[WOTPivotAppManager sharedInstance] coreDataProvider];
    NSManagedObjectContext *context = [dataProvider mainContext];
    id result = [context executeFetchRequest:request error:&error];
    
    if ([result count] == 0) {
        
        return NULL;
    } else {
        
        CGFloat thisValue = [[result lastObject][@"this"] floatValue];
        CGFloat maxValue = [[result lastObject][@"max"] floatValue];
        CGFloat averageValue = [[result lastObject][@"av"] floatValue];
        WOTTankEvalutionResult *returningValue = [[WOTTankEvalutionResult alloc] initWithThisValue:thisValue
                                                                                          maxValue:maxValue
                                                                                      averageValue:averageValue];
        return returningValue;
    }
}

@end

@implementation WOTMetric (Samples)

+ (id<WOTMetricProtocol>)standardCompareMetricForClass:(Class)clazz byExpression:(WOTTankDetailFieldExpression *)expression withName:(NSString *)name groupName:(NSString *)groupName {
    
    StandardCompareMetricEvaluator *standard = [[StandardCompareMetricEvaluator alloc] init];
    standard.clazz = clazz;
    standard.expression = expression;
    return [[WOTMetric alloc] initWithMetricName:name grouppingName:groupName evaluator: standard];
}

//+ (id<WOTMetricProtocol>)suspensionRotationSpeedCompareMetric {
//
//    return [self standardCompareMetricForClass:[Tankchassis class]
//                                  byExpression:[WOTTankDetailFieldExpression suspensionRotationSpeedCompareFieldExpression]
//                                      withName:WOTString(WOTApiKeys.rotation_speed)
//                                     groupName:WOTString(WOT_STRING_MOBI)];
//}
//
//+ (id<WOTMetricProtocol>)fireStartingChanceCompareMetric {
//
//    return [self standardCompareMetricForClass:[Tankengines class]
//                                  byExpression:[WOTTankDetailFieldExpression engineFireStartingChanceCompareFieldExpression]
//                                      withName:WOTString(WOTApiKeys.fire_starting_chance)
//                                     groupName:WOTString(WOT_STRING_MOBI)];
//}
//
//+ (id<WOTMetricProtocol>)circularVisionCompareMetric {
//
//    return [self standardCompareMetricForClass:[Tankturrets class]
//                                  byExpression:[WOTTankDetailFieldExpression turretsCircularVisionRadiusCompareFieldExpression]
//                                      withName:WOTString(WOTApiKeys.circular_vision_radius)
//                                     groupName:WOTString(WOT_STRING_OBSERVE)];
//
//}
//
//+ (id<WOTMetricProtocol>)armorBoardCompareMetric {
//
//    return [self standardCompareMetricForClass:[Tankturrets class]
//                                  byExpression:[WOTTankDetailFieldExpression turretsArmorBoardCompareFieldExpression]
//                                      withName:WOTString(WOTApiKeys.armor_board)
//                                     groupName:WOTString(WOT_STRING_ARMOR)];
//}
//
//+ (id<WOTMetricProtocol>)armorFeddCompareMetric {
//
//    return [self standardCompareMetricForClass:[Tankturrets class]
//                                  byExpression:[WOTTankDetailFieldExpression turretsArmorFeddCompareFieldExpression]
//                                      withName:WOTString(WOTApiKeys.armor_fedd)
//                                     groupName:WOTString(WOT_STRING_ARMOR)];
//}
//
//+ (id<WOTMetricProtocol>)armorForeheadCompareMetric {
//
//
//    return [self standardCompareMetricForClass:[Tankturrets class]
//                                  byExpression:[WOTTankDetailFieldExpression turretsArmorForeheadCompareFieldExpression]
//                                      withName:WOTString(WOTApiKeys.armor_forehead)
//                                     groupName:WOTString(WOT_STRING_ARMOR)];
//}

+ (NSArray *)metricsForOptions:(WOTTankMetricOptions *) option {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([option isInclude:WOTTankMetricOptions.armor]) {
        
//        [result addObject:[WOTMetric armorBoardCompareMetric]];
//        [result addObject:[WOTMetric armorFeddCompareMetric]];
//        [result addObject:[WOTMetric armorForeheadCompareMetric]];
    }
    
    if ([option isInclude:WOTTankMetricOptions.mobility]) {
        
//        [result addObject:[WOTMetric fireStartingChanceCompareMetric]];
//        [result addObject:[WOTMetric suspensionRotationSpeedCompareMetric]];
    }
    
    if ([option isInclude:WOTTankMetricOptions.observe]) {
        
//        [result addObject:[WOTMetric circularVisionCompareMetric]];
    }
    return result;
}

@end

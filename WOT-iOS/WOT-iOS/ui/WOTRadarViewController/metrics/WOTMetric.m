//
//  WOTMetric.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMetric.h"
#import "WOTCoreDataProvider.h"
#import "Tankengines.h"
#import "Tankturrets.h"
#import "WOTTankDetailFieldExpression+Factory.h"


@interface WOTMetric ()

@property (nonatomic, readwrite, strong)NSString *metricName;
@property (nonatomic, readwrite, strong)WOTTankMetricEvaluator evaluator;

@end

static CGFloat const mult = 10.0f;

@implementation WOTMetric

+ (id<WOTTankMetricProtocol>)circularVisionMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_CIRCULAR_VISION_RADIUS) evaluator:^float(WOTTankID *tankID) {
        
        
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
        
        float thisValue = [[result lastObject][@"this"] floatValue];
//        float maxValue = [[result lastObject][@"max"] floatValue];
//        float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue );
        return (thisValue == 0)?1.0f:thisValue;
    }];
}

+ (id<WOTTankMetricProtocol>)armorBoardMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_BOARD) evaluator:^float(WOTTankID *tankID) {
        
        
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

        float thisValue = [[result lastObject][@"this"] floatValue];
//        float maxValue = [[result lastObject][@"max"] floatValue];
//        float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue );
        return (thisValue == 0)?1.0f:thisValue;
    }];
}

+ (id<WOTTankMetricProtocol>)armorFeddMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_FEDD) evaluator:^float(WOTTankID *tankID) {
        
        
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
        
        float thisValue = [[result lastObject][@"this"] floatValue];
        float maxValue = [[result lastObject][@"max"] floatValue];
        float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue );
        return (thisValue == 0)?1.0f:thisValue;
    }];
}

+ (id<WOTTankMetricProtocol>)armorForeheadMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_ARMOR_FOREHEAD) evaluator:^float(WOTTankID *tankID) {
        
        
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
        
        float thisValue = [[result lastObject][@"this"] floatValue];
//        float maxValue = [[result lastObject][@"max"] floatValue];
//        float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue );
        return (thisValue == 0)?1.0f:thisValue;
    }];
}

+ (id<WOTTankMetricProtocol>)fireStartingChanceMetric {
    
    return [[WOTMetric alloc] initWithMetricName:WOTString(WOT_KEY_FIRE_STARTING_CHANCE) evaluator:^float(WOTTankID *tankID) {
        
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
        
        float thisValue = [[result lastObject][@"this"] floatValue];
//        float maxValue = [[result lastObject][@"max"] floatValue];
//        float floatResult = (maxValue == 0)?1.0f:(thisValue / maxValue );
        return (thisValue == 0)?1.0f:thisValue;
    }];
}


- (id)initWithMetricName:(NSString *)ametricName evaluator:(WOTTankMetricEvaluator)aevaluator {
    
    self = [super init];
    if (self){
        
        self.metricName = ametricName;
        self.evaluator = aevaluator;
    }
    return self;
}

@end

//
//  WOTTankAllDataMetric.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankAllDataMetric.h"
#import "WOTTankMetricProtocol.h"

@interface WOTTankAllDataMetric ()

@property (nonatomic, readonly)NSArray *datasets;
@property (nonatomic, readonly)NSArray *xVals;
@property (nonatomic, strong)NSMutableSet *metrics;
@property (nonatomic, strong)NSMutableSet *tankIDs;

@end

@implementation WOTTankAllDataMetric

- (void)addMetric:(id<WOTTankMetricProtocol>)metric {
 
    if (!self.metrics) {
        
        self.metrics = [[NSMutableSet alloc] init];
    }
    
    [self.metrics addObject:metric];
    
}

- (void)removeMetric:(id<WOTTankMetricProtocol>)metric {
    
    [self.metrics removeObject:metric];
    
}

- (void)addTankID:(WOTTankID *)tankID {
    
    if (!self.tankIDs) {
        
        self.tankIDs = [[NSMutableSet alloc] init];
    }
    
    [self.tankIDs addObject:tankID];
}

- (void)removeTankID:(WOTTankID *)tankID {
    
    [self.tankIDs removeObject:tankID];
}

- (NSArray *)datasets {
    
    NSMutableSet *result = [[NSMutableSet alloc] init];
    
    __block NSInteger index = 0;
    [self.tankIDs enumerateObjectsUsingBlock:^(WOTTankID *tankID, BOOL *stop) {
       
        [result addObject:[self datasetForTankID:tankID atIndex:index]];
        index++;
    }];
    
    return [result allObjects];
}


- (NSArray *)xVals {

    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.metrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> obj, BOOL *stop) {
        
        [result addObject:obj.metricName];
    }];
    return result;
}

- (RadarChartDataSet *)datasetForTankID:(WOTTankID *)tankID atIndex:(NSInteger)index {
    
    NSArray *yVals = [self yValsForTankID:tankID];
    RadarChartDataSet *result = [[RadarChartDataSet alloc] initWithYVals:yVals label:tankID.label];
    [result setColor:ChartColorTemplates.vordiplom[index]];
    result.drawFilledEnabled = YES;
    result.lineWidth = 0.75;//2.0;
    return result;
}


- (NSArray *)yValsForTankID:(WOTTankID *)tankID {
    
    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    __block NSInteger index = 0;
    
    [self.metrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> obj, BOOL *stop) {
        
        float value = 0;
        if (obj.evaluator) {
            
            value = obj.evaluator(tankID);
        }
        [result addObject:[[ChartDataEntry alloc] initWithValue:value xIndex:index]];
        index++;
        
        
    }];
    return result;
}

- (RadarChartData *)chartData {

    RadarChartData *result =  [[RadarChartData alloc] initWithXVals:self.xVals dataSets:self.datasets];
    [result setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [result setDrawValues:NO];
    return result;
}

@end

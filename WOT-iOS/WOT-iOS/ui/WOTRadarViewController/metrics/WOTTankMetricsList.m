//
//  WOTTankMetricsList.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankMetricsList.h"
#import "WOTTankMetricProtocol.h"

@interface WOTTankMetricsList ()

@property (nonatomic, readonly)NSArray *datasets;
@property (nonatomic, readonly)NSArray *xVals;
@property (nonatomic, strong)NSMutableSet *metrics;
@property (nonatomic, strong)NSMutableSet *tankIDs;

@end

@implementation WOTTankMetricsList

- (void)addMetrics:(NSArray *)metricsArray {

    if (!self.metrics) {
        
        self.metrics = [[NSMutableSet alloc] init];
    }
    [self.metrics addObjectsFromArray:metricsArray];
}

- (void)addMetric:(id<WOTTankMetricProtocol>)metric {
 
    if (!self.metrics) {
        
        self.metrics = [[NSMutableSet alloc] init];
    }
    
    [self.metrics addObject:metric];
    
}

- (void)removeMetric:(id<WOTTankMetricProtocol>)metric {
    
    [self.metrics removeObject:metric];
    
}

- (void)addTankID:(WOTTanksIDList *)tankID {
    
    if (!self.tankIDs) {
        
        self.tankIDs = [[NSMutableSet alloc] init];
    }
    
    [self.tankIDs addObject:tankID];
}

- (void)removeTankID:(WOTTanksIDList *)tankID {
    
    [self.tankIDs removeObject:tankID];
}

- (NSArray *)datasets {
    
    __block NSMutableArray *result = nil;
    
    __block NSInteger index = 0;
    [self.tankIDs enumerateObjectsUsingBlock:^(WOTTanksIDList *tankIDList, BOOL *stop) {
       
        RadarChartDataSet *dataset = [self datasetForTanksIDList:tankIDList atIndex:index];
        if (dataset){
            
            if (!result) {
                
                result = [[NSMutableArray alloc] init];
            }
            [result addObject:dataset];
        }
        index++;
    }];
    
    return result;
}


- (NSArray *)xVals {

    NSArray *sortedMetrics = [self sortedMetrics];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> obj, NSUInteger idx, BOOL *stop) {
        
        [result addObject:obj.metricName];
    }];
    return result;
}

- (RadarChartDataSet *)datasetForTanksIDList:(WOTTanksIDList *)tankIDList atIndex:(NSInteger)index {
    
    NSArray *yVals = [self yValsForTanksIDList:tankIDList];
    if (!yVals) {
        
        return nil;
    } else {
        
        RadarChartDataSet *result = [[RadarChartDataSet alloc] initWithYVals:yVals label:tankIDList.label];
        [result setColor:ChartColorTemplates.vordiplom[index]];
        result.drawFilledEnabled = YES;
        result.lineWidth = 0.75;//2.0;
        return result;
    }
}

- (NSArray *)sortedMetrics {
    
    NSArray *sortedArray = [[self.metrics allObjects] sortedArrayUsingComparator:^NSComparisonResult(id<WOTTankMetricProtocol> obj1, id<WOTTankMetricProtocol> obj2) {
        
        return [[obj1 metricName] compare:[obj2 metricName]];
    }];
    return sortedArray;
}

- (NSArray *)yValsForTanksIDList:(WOTTanksIDList *)tankIDList {
    
    __block NSMutableArray *result = nil;
    __block NSInteger index = 0;
    
    NSArray *sortedMetrics = [self sortedMetrics];
    [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> metric, NSUInteger idx, BOOL *stop) {
        
        float value = 0;
        if (metric.evaluator) {
            
            value = metric.evaluator(tankIDList);
        }
        if (!isnan(value)){
            
            if (!result) {
                
                result = [[NSMutableArray alloc] init];
            }
            
            [result addObject:[[ChartDataEntry alloc] initWithValue:value xIndex:index]];
            index++;
        }
        
        
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

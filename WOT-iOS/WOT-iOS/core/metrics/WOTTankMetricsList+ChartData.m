//
//  WOTTankMetricsList+ChartData.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/10/16.
//  Copyright © 2016 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankMetricsList+ChartData.h"

@implementation WOTTankMetricsList (ChartData)


//- (RadarChartData *)chartData {
//
//    RadarChartData *result =  [[RadarChartData alloc] initWithXVals:self.xVals dataSets:self.datasets];
//    [result setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
//    [result setDrawValues:NO];
//    return result;
//}
//

#pragma mark - private

- (NSArray *)xVals {
    
    NSArray *sortedMetrics = [self sortedMetrics];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> obj, NSUInteger idx, BOOL *stop) {
        
        [result addObject:obj.metricName];
    }];
    return result;
}

- (NSArray *)datasets {
    
    __block NSMutableArray *result = nil;
    
    __block NSInteger index = 0;
    [self.tankIDs enumerateObjectsUsingBlock:^(WOTTanksIDList *tankIDList, BOOL *stop) {
        
//        RadarChartDataSet *dataset = [self datasetForTanksIDList:tankIDList atIndex:index];
//        if (dataset){
//
//            if (!result) {
//
//                result = [[NSMutableArray alloc] init];
//            }
//            [result addObject:dataset];
//        }
        index++;
    }];
    
    return result;
}

//- (RadarChartDataSet *)datasetForTanksIDList:(WOTTanksIDList *)tankIDList atIndex:(NSInteger)index {
//
//    NSArray *yVals = [self yValsForTanksIDList:tankIDList];
//    if (!yVals) {
//
//        return nil;
//    } else {
//
//        RadarChartDataSet *result = [[RadarChartDataSet alloc] initWithYVals:yVals label:tankIDList.label];
//        [result setColor:ChartColorTemplates.vordiplom[index]];
//        result.drawFilledEnabled = YES;
//        result.lineWidth = 0.75;//2.0;
//        return result;
//    }
//}

- (NSArray *)yValsForTanksIDList:(WOTTanksIDList *)tankIDList {
    
    __block NSMutableArray *result = nil;
    __block NSInteger index = 0;
    
    NSArray *sortedMetrics = [self sortedMetrics];
    [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> metric, NSUInteger idx, BOOL *stop) {
        
        WOTTankEvalutionResult *value;
        if (metric.evaluator) {
            
            value = metric.evaluator(tankIDList);
        }
        
        if (value != NULL) {
            
            if (!result) {
                
                result = [[NSMutableArray alloc] init];
            }
            
//            [result addObject:[[ChartDataEntry alloc] initWithValue:value.thisValue xIndex:index]];
//            //            [result addObject:[[ChartDataEntry alloc] initWithValue:value.maxValue xIndex:index]];
//            //            [result addObject:[[ChartDataEntry alloc] initWithValue:value.averageValue xIndex:index]];
            index++;
        }
        
        
    }];
    
    return result;
}
@end

//
//  WOTTankMetricList.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

#warning ("use WOTMetricProtocol instead of WOTMetric")

@objc
public protocol WOTTankMetricsListProtocol {
    var sortedMetrics: [WOTMetric] { get }
    func add(tankId: WOTTanksIDList)
    func remove(tankId: WOTTanksIDList)
    func add(metrics: [WOTMetric])
    func add(metric: WOTMetric)
    func remove(metric: WOTMetric)
}

@objc
public class WOTTankMetricsList: NSObject {
    public var sortedMetrics: [WOTMetric] {
        return self.metrics.sorted { (obj1, obj2) -> Bool in
            guard let name1 = obj1.metricName, let name2 = obj2.metricName else { return false }
            return name1.compare(name2) == .orderedAscending
        }
    }

    private var metrics =  Set<WOTMetric>()
    private var tankIDLists =  Set<WOTTanksIDList>()

    @objc
    public func add(tankId: WOTTanksIDList) {
        self.tankIDLists.insert(tankId)
    }

    @objc
    public func remove(tankId: WOTTanksIDList) {
        self.tankIDLists.remove(tankId)
    }

    @objc
    public func add(metrics: [WOTMetric]) {
        metrics.forEach {
            self.metrics.insert($0)
        }
    }

    @objc
    public func add(metric: WOTMetric) {
        self.metrics.insert(metric)
    }

    @objc
    public func remove(metric: WOTMetric) {
        self.metrics.remove(metric)
    }
}

@objc
public protocol ChartDataProtocol {
    var datasets: [Any] { get }
    var xVals: [Any] { get }
    var chartData: Any { get }
}

extension WOTTankMetricsList: ChartDataProtocol {
    public var datasets: [Any] {
        /*
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

         */
        return [""]
    }

    public var xVals: [Any] {
        /*
         NSArray *sortedMetrics = [self sortedMetrics];
         NSMutableArray *result = [[NSMutableArray alloc] init];
         [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> obj, NSUInteger idx, BOOL *stop) {

             [result addObject:obj.metricName];
         }];
         return result;

         */
        return [""]
    }

    public var chartData: Any {
        //    RadarChartData *result =  [[RadarChartData alloc] initWithXVals:self.xVals dataSets:self.datasets];
        //    [result setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
        //    [result setDrawValues:NO];
        //    return result;
        return ""
    }

    private func dataset(tankIDList: WOTTanksIDList, atIndex: Int) -> Any {
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

        return ""
    }

    private func yVals(tankIDList: WOTTanksIDList) -> [Any] {
        /*
             __block NSMutableArray *result = nil;
             __block NSInteger index = 0;

             NSArray *sortedMetrics = [self sortedMetrics];
             [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol> metric, NSUInteger idx, BOOL *stop) {

                 WOTTankEvalutionResultProtocol *value;
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

         */
        return [""]
    }
}

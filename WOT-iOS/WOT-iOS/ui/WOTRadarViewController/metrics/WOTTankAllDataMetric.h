//
//  WOTTankAllDataMetric.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOT_iOS-Swift.h"
#import "WOTTankMetricProtocol.h"
#import "WOTTankID.h"

@interface WOTTankAllDataMetric : NSObject

@property (nonatomic, readonly)RadarChartData *chartData;

- (void)addMetric:(id<WOTTankMetricProtocol>)metric;
- (void)removeMetric:(id<WOTTankMetricProtocol>)metric;

- (void)addTankID:(WOTTankID *)tankID;
- (void)removeTankID:(WOTTankID *)tankID;

@end

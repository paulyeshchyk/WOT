//
//  WOTMetric+Samples.h
//  WOT-iOS
//
//  Created on 7/28/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTMetric.h"
#import "WOTTankMetricOptions.h"

@interface WOTMetric (Samples)

+ (id<WOTTankMetricProtocol>)circularVisionCompareMetric;
+ (id<WOTTankMetricProtocol>)armorBoardCompareMetric;
+ (id<WOTTankMetricProtocol>)armorFeddCompareMetric;
+ (id<WOTTankMetricProtocol>)armorForeheadCompareMetric;
+ (id<WOTTankMetricProtocol>)fireStartingChanceCompareMetric;
+ (id<WOTTankMetricProtocol>)suspensionRotationSpeedCompareMetric;

+ (NSArray *)metricsForOptions:(WOTTankMetricOptions) option;

@end

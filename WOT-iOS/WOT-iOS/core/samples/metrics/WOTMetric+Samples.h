//
//  WOTMetric+Samples.h
//  WOT-iOS
//
//  Created on 7/28/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WOTPivot/WOTPivot-Swift.h>

@interface WOTMetric (Samples)

//+ (id<WOTMetricProtocol>)circularVisionCompareMetric;
//+ (id<WOTMetricProtocol>)armorBoardCompareMetric;
//+ (id<WOTMetricProtocol>)armorFeddCompareMetric;
//+ (id<WOTMetricProtocol>)armorForeheadCompareMetric;
//+ (id<WOTMetricProtocol>)fireStartingChanceCompareMetric;
//+ (id<WOTMetricProtocol>)suspensionRotationSpeedCompareMetric;

+ (NSArray *)metricsForOptions:(WOTTankMetricOptions *) option;

@end

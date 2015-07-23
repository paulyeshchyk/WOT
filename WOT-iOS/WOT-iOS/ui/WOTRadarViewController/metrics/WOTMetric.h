//
//  WOTMetric.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTTankMetricProtocol.h"

@interface WOTMetric : NSObject <WOTTankMetricProtocol>

+ (id<WOTTankMetricProtocol>)circularVisionMetric;
+ (id<WOTTankMetricProtocol>)armorBoardMetric;
+ (id<WOTTankMetricProtocol>)armorFeddMetric;
+ (id<WOTTankMetricProtocol>)armorForeheadMetric;
+ (id<WOTTankMetricProtocol>)fireStartingChanceMetric;

- (id)initWithMetricName:(NSString *)metricName evaluator:(WOTTankMetricEvaluator)evaluator;

@end

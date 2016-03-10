//
//  WOTMetric.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTTankMetricProtocol.h"
#import "WOTTankMetricOptions.h"


@interface WOTMetric : NSObject <WOTTankMetricProtocol>

+ (BOOL)options:(WOTTankMetricOptions)sourceOption includesOption:(WOTTankMetricOptions)option;
+ (WOTTankMetricOptions)options:(WOTTankMetricOptions)options invertOption:(WOTTankMetricOptions)option ;

- (id)initWithMetricName:(NSString *)ametricName grouppingName:(NSString *)agrouppingName evaluator:(WOTTankMetricEvaluator)aevaluator;

@end

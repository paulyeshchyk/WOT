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

- (id)initWithMetricName:(NSString *)ametricName grouppingName:(NSString *)agrouppingName evaluator:(WOTTankMetricEvaluator)aevaluator;

@end

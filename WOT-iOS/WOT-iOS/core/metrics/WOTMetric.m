//
//  WOTMetric.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMetric.h"


@interface WOTMetric ()

@property (nonatomic, readwrite, strong)NSString *metricName;
@property (nonatomic, readwrite, strong)WOTTankMetricEvaluator evaluator;

@end


@implementation WOTMetric

- (id)initWithMetricName:(NSString *)ametricName evaluator:(WOTTankMetricEvaluator)aevaluator {
    
    self = [super init];
    if (self){
        
        self.metricName = ametricName;
        self.evaluator = aevaluator;
    }
    return self;
}

@end

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
@property (nonatomic, readwrite, strong)NSString *grouppingName;

@end


@implementation WOTMetric

- (id)initWithMetricName:(NSString *)ametricName grouppingName:(NSString *)agrouppingName evaluator:(WOTTankMetricEvaluator)aevaluator{
    
    self = [super init];
    if (self){
        
        self.metricName = ametricName;
        self.evaluator = aevaluator;
        self.grouppingName = agrouppingName;
    }
    return self;
}

@end
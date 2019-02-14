//
//  WOTMetric.m
//  WOT-iOS
//
//  Created on 7/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTMetric.h"


@interface WOTMetric ()

@property (nonatomic, readwrite, strong)NSString *metricName;
@property (nonatomic, readwrite, strong)WOTTankMetricEvaluator evaluator;
@property (nonatomic, readwrite, strong)NSString *grouppingName;

@end

@implementation WOTMetric

+ (BOOL)options:(WOTTankMetricOptions)sourceOption includesOption:(WOTTankMetricOptions)option {
    
    return ((sourceOption & option) == option);
}

+ (WOTTankMetricOptions)options:(WOTTankMetricOptions)options invertOption:(WOTTankMetricOptions)option {
    
    if ([WOTMetric options:options includesOption:option]) {
        
        return options &= ~option;
    } else {
        
        return options |= option;
    }
}

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

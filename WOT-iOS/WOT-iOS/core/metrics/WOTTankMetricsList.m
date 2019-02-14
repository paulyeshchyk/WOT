//
//  WOTTankMetricsList.m
//  WOT-iOS
//
//  Created on 7/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankMetricsList.h"
#import "WOTTankMetricProtocol.h"

@interface WOTTankMetricsList ()

@property (nonatomic, strong)NSMutableSet *metrics;

@end

@implementation WOTTankMetricsList

- (void)addMetrics:(NSArray *)metricsArray {

    if (!self.metrics) {
        
        self.metrics = [[NSMutableSet alloc] init];
    }
    [self.metrics addObjectsFromArray:metricsArray];
}

- (void)addMetric:(id<WOTTankMetricProtocol>)metric {
 
    if (!self.metrics) {
        
        self.metrics = [[NSMutableSet alloc] init];
    }
    
    [self.metrics addObject:metric];
}

- (void)removeMetric:(id<WOTTankMetricProtocol>)metric {
    
    [self.metrics removeObject:metric];
}

- (void)addTankID:(WOTTanksIDList *)tankID {
    
    if (!self.tankIDs) {
        
        self.tankIDs = [[NSMutableSet alloc] init];
    }
    
    [self.tankIDs addObject:tankID];
}

- (void)removeTankID:(WOTTanksIDList *)tankID {
    
    [self.tankIDs removeObject:tankID];
}

- (NSArray *)sortedMetrics {
    
    NSArray *sortedArray = [[self.metrics allObjects] sortedArrayUsingComparator:^NSComparisonResult(id<WOTTankMetricProtocol> obj1, id<WOTTankMetricProtocol> obj2) {
        
        return [[obj1 metricName] compare:[obj2 metricName]];
    }];
    return sortedArray;
}


@end

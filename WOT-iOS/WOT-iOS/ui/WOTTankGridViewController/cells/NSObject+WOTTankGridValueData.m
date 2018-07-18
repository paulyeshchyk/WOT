//
//  NSObject+WOTTankGridValueData.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/18/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

#import "NSObject+WOTTankGridValueData.h"

@implementation NSObject (WOTTankGridValueData)

+ (NSString *)gridValueData:(id)node {
//    
//    WOTTankEvalutionResult *value = node.gridNodeData;
//    return [NSString stringWithFormat:@"%2.3f",value.thisValue];
    return @"";
}

+ (WOTPivotTreeSwift *)gridData:(WOTTankMetricsList *)metrics {
    return nil;
//    WOTTree *tree = [[WOTTree alloc] init];
//
//    NSArray *sortedMetrics = [metrics sortedMetrics];
//
//    [metrics.tankIDs enumerateObjectsUsingBlock:^(id  tankId, BOOL * _Nonnull stopTankId) {
//
//        [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol>  metric, NSUInteger idx, BOOL * _Nonnull stopMetric) {
//
//            WOTTankEvalutionResult *value;
//            if (metric.evaluator) {
//
//                value = metric.evaluator(tankId);
//            }
//
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",metric.grouppingName];
//            WOTNode *rootNode = [tree findOrCreateRootNodeByPredicate:predicate];
//            [rootNode setName:metric.grouppingName];
//
//            if (value != NULL) {
//
//                WOTNode *node = [[WOTNode alloc] initWithName:metric.metricName gridData:value];
//                [rootNode addChild:node];
//            }
//        }];
//
//    }];
//
//    return tree;

}

@end

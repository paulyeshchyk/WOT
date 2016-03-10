//
//  WOTTankMetricsList+GridData.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/10/16.
//  Copyright © 2016 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankMetricsList+GridData.h"
#import "WOTTankMetricOptions.h"
#import "WOTMetric+Samples.h"
#import "WOTNode+DetailGrid.h"
#import "WOTTree+DetailGrid.h"

@interface TestGridChild : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *group;
@property (nonatomic, assign)id value;

- (NSDictionary *)dictionaryValue;

@end


@implementation TestGridChild

- (NSDictionary *)dictionaryValue {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    result[self.name] = self.value;
    
    return result;
}

@end

@implementation WOTTankMetricsList (GridData)

- (WOTTree *)gridData {

    WOTTree *tree = [[WOTTree alloc] init];
    
    NSArray *sortedMetrics = [self sortedMetrics];

    [self.tankIDs enumerateObjectsUsingBlock:^(id  tankId, BOOL * _Nonnull stopTankId) {

        [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol>  metric, NSUInteger idx, BOOL * _Nonnull stopMetric) {
            
            WOTTankEvalutionResult *value;
            if (metric.evaluator) {
                
                value = metric.evaluator(tankId);
            }

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",metric.grouppingName];
            WOTNode *rootNode = [tree findOrCreateRootNodeByPredicate:predicate];
            [rootNode setName:metric.grouppingName];

            if (value != NULL) {
                
                WOTNode *node = [[WOTNode alloc] initWithName:metric.metricName gridData:value];
                [rootNode addChild:node];
            }
        }];
        
    }];
    
    return tree;
}

@end

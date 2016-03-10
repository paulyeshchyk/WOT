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
#import "WOTTree.h"

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

- (id)gridData {

    WOTTree *tree = [[WOTTree alloc] init];
    
    NSArray *sortedMetrics = [self sortedMetrics];

    [self.tankIDs enumerateObjectsUsingBlock:^(id  tankId, BOOL * _Nonnull stopTankId) {

        [sortedMetrics enumerateObjectsUsingBlock:^(id<WOTTankMetricProtocol>  metric, NSUInteger idx, BOOL * _Nonnull stopMetric) {
            
            WOTTankEvalutionResult *value;
            if (metric.evaluator) {
                
                value = metric.evaluator(tankId);
            }
            
            WOTNode *rootNode = nil;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",metric.grouppingName];
            NSSet *roots = [tree.rootNodes filteredSetUsingPredicate:predicate];
            if ([roots count]  == 0) {
                
                rootNode = [[WOTNode alloc] initWithName:metric.grouppingName];
                [tree addNode:rootNode];
            } else {
                
                rootNode = [roots anyObject];
            }

            
            if (value != NULL) {
                
                WOTNode *node = [[WOTNode alloc] initWithName:metric.metricName gridData:value];
                [rootNode addChild:node];
            }
        }];
        
    }];
    
    return tree;
//    
//    NSArray *data = @[@{@"metricOptions":@(WOTTankMetricOptionsMobi), @"children":@{@"0_Mobi_0":@"000",@"0_Mobi_1":@"001"}, @"caption":@"0_Mobi"},
//                      @{@"metricOptions":@(WOTTankMetricOptionsObse), @"children":@{@"2_Obse_0":@"200",@"2_Obse_1":@"201",@"2_Obse_2":@"202"}, @"caption":@"2_Obse"},
//                      @{@"metricOptions":@(WOTTankMetricOptionsArmo), @"children":@{@"1_Armo_0":@"100",@"1_Armo_1":@"101",@"1_Armo_2":@"102",@"1_Armo_3":@"103",@"1_Armo_4":@"104",@"1_Armo_5":@"105",@"1_Armo_6":@"106",@"1_Armo_7":@"107"}, @"caption":@"1_Armo"},
//                      @{@"metricOptions":@(WOTTankMetricOptionsFire), @"children":@{@"3_Fire_0":@"300",@"3_Fire_1":@"301",@"3_Fire_2":@"302",@"3_Fire_3":@"303",@"3_Fire_4":@"304",@"3_Fire_5":@"305"}, @"caption":@"3_Fire"}
//                      ];
//    
//    
//    WOTTankMetricOptions metricOptions = WOTTankMetricOptionsArmo;
//    
//    NSMutableArray *andPredicates = [[NSMutableArray alloc] init];
//    if ([WOTMetric options:metricOptions includesOption:WOTTankMetricOptionsMobi]) {
//        
//        [andPredicates addObject:[NSPredicate predicateWithFormat:@"metricOptions == %d",WOTTankMetricOptionsMobi]];
//    }
//    
//    if ([WOTMetric options:metricOptions includesOption:WOTTankMetricOptionsArmo]) {
//        
//        [andPredicates addObject:[NSPredicate predicateWithFormat:@"metricOptions == %d",WOTTankMetricOptionsArmo]];
//    }
//    
//    if ([WOTMetric options:metricOptions includesOption:WOTTankMetricOptionsObse]) {
//        
//        [andPredicates addObject:[NSPredicate predicateWithFormat:@"metricOptions == %d",WOTTankMetricOptionsObse]];
//    }
//    
//    if ([WOTMetric options:metricOptions includesOption:WOTTankMetricOptionsFire]){
//        
//        [andPredicates addObject:[NSPredicate predicateWithFormat:@"metricOptions == %d",WOTTankMetricOptionsFire]];
//    }
//    
//    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:andPredicates];
//    
//    NSArray *result = [data filteredArrayUsingPredicate:predicate];
//    
//    return result;
}

@end

//
//  WOTNode+PivotFactory.m
//  WOT-iOS
//
//  Created on 8/25/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTNode+PivotFactory.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi-Swift.h>
#import <UIKit/UIKit.h>

@implementation WOTNodeFactory 

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotEmptyNode {
    id<WOTPivotNodeProtocol> node = [[WOTPivotDataNode alloc] initWithName:@""];
    return node;
}

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotDataNodeForPredicate:(NSPredicate * _Nullable)predicate andVehicle:(id _Nonnull)vehicle {
    
    Vehicles *vehicles = vehicle;
    id<WOTPivotNodeProtocol> node = [[WOTPivotDataNode alloc] initWithName:vehicles.name];

    node.predicate = predicate;
//    node.imageURL = [NSURL URLWithString:tanks.image];
//
    node.dataColor = [WOTNodeFactory typeColors][vehicles.type];

    [node setData1:vehicles];
    return node;
}

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotDataNodeGroupForPredicate:(NSPredicate * _Nullable)predicate andTanksObjects:(NSArray * _Nonnull)tanksObjects {

    WOTPivotDataGroupNode *nodeGroup = [[WOTPivotDataGroupNode alloc] initWithName:@"Group1"];
    nodeGroup.fetchedObjects = tanksObjects;
    return nodeGroup;
}

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotWeightMetadataItemAsType:(PivotMetadataType)type {

    Class PivotNodeClass = [WOTPivotMetaTypeConverter nodeClassFor:type];
    id<WOTPivotNodeProtocol> result = [[PivotNodeClass alloc] initWithName:@"Weight"];


    NSPredicate *predicateLess1K = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_weight, 1*1000];
    NSPredicate *predicateLess5K = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_weight, 5*1000];
    NSPredicate *predicateLess10K = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_weight, 10*1000];
    NSPredicate *predicateLess25K = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_weight, 25*1000];
    NSPredicate *predicateLess50K = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_weight, 50*1000];
    NSPredicate *predicateLess100K = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_weight, 100*1000];

    NSPredicate *predicateGr1K = [NSPredicate predicateWithFormat:@"%K > %d", WOTApiForeignKeys.vehicles_default_profile_weight, 1*1000];
    NSPredicate *predicateGr5K = [NSPredicate predicateWithFormat:@"%K > %d", WOTApiForeignKeys.vehicles_default_profile_weight, 5*1000];
    NSPredicate *predicateGr10K = [NSPredicate predicateWithFormat:@"%K > %d", WOTApiForeignKeys.vehicles_default_profile_weight, 10*1000];
    NSPredicate *predicateGr25K = [NSPredicate predicateWithFormat:@"%K > %d", WOTApiForeignKeys.vehicles_default_profile_weight, 25*1000];
    NSPredicate *predicateGr50K = [NSPredicate predicateWithFormat:@"%K > %d", WOTApiForeignKeys.vehicles_default_profile_weight, 50*1000];
    NSPredicate *predicateGr100K = [NSPredicate predicateWithFormat:@"%K > %d", WOTApiForeignKeys.vehicles_default_profile_weight, 100*1000];

    [result addChild:[[PivotNodeClass alloc] initWithName:@"(1k]"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateLess1K]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"(1K;5K]"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr1K, predicateLess5K]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"(5K;10K]"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr5K, predicateLess10K]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"(10K;25K]"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr10K, predicateLess25K]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"(25K;50K]"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr25K, predicateLess50K]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"(50K;100K]"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr50K, predicateLess100K]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"[100K)"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr100K]]]];

    return result;
}

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotHPMetadataItemAsType:(PivotMetadataType)type {

    Class PivotNodeClass = [WOTPivotMetaTypeConverter nodeClassFor:type];
    id<WOTPivotNodeProtocol> result = [[PivotNodeClass alloc] initWithName:@"HP"];


    NSPredicate *predicateGr100 = [NSPredicate predicateWithFormat:@"%K >= %d", WOTApiForeignKeys.vehicles_default_profile_hp, 100];
    NSPredicate *predicateGr200 = [NSPredicate predicateWithFormat:@"%K >= %d", WOTApiForeignKeys.vehicles_default_profile_hp, 200];
    NSPredicate *predicateGr400 = [NSPredicate predicateWithFormat:@"%K >= %d", WOTApiForeignKeys.vehicles_default_profile_hp, 400];
    NSPredicate *predicateGr800 = [NSPredicate predicateWithFormat:@"%K >= %d", WOTApiForeignKeys.vehicles_default_profile_hp, 800];
    NSPredicate *predicateGr1600 = [NSPredicate predicateWithFormat:@"%K >= %d", WOTApiForeignKeys.vehicles_default_profile_hp, 1600];
    NSPredicate *predicateGr5000 = [NSPredicate predicateWithFormat:@"%K >= %d", WOTApiForeignKeys.vehicles_default_profile_hp, 5000];
    NSPredicate *predicateLess100 = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_hp, 100];
    NSPredicate *predicateLess200 = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_hp, 200];
    NSPredicate *predicateLess400 = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_hp, 400];
    NSPredicate *predicateLess800 = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_hp, 800];
    NSPredicate *predicateLess1600 = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_hp, 1600];
    NSPredicate *predicateLess5000 = [NSPredicate predicateWithFormat:@"%K < %d", WOTApiForeignKeys.vehicles_default_profile_hp, 5000];

    [result addChild:[[PivotNodeClass alloc] initWithName:@"<100"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateLess100]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"<200"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr100, predicateLess200]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"<400"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr200, predicateLess400]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"<800"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr400, predicateLess800]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"<1600"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr800, predicateLess1600]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"<5000"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr1600, predicateLess5000]]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@">=5000"  predicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateGr5000]]]];

    return result;
}

+ (NSDictionary * _Nonnull)nationColors {
    
    return @{NSLocalizedString(@"usa", nil):     [[UIColor purpleColor] paleColor],
             NSLocalizedString(@"ussr", nil):    [[UIColor redColor] paleColor],
             NSLocalizedString(@"japan", nil):   [[UIColor orangeColor] paleColor],
             NSLocalizedString(@"china", nil):   [[UIColor yellowColor] paleColor],
             NSLocalizedString(@"germany", nil): [[UIColor brownColor] paleColor],
             NSLocalizedString(@"france", nil):  [[UIColor greenColor] paleColor],
             NSLocalizedString(@"poland", nil):  [[UIColor whiteColor] paleColor],
             NSLocalizedString(@"sweden", nil):  [[UIColor blueColor] paleColor],
             NSLocalizedString(@"czech", nil):   [[UIColor cyanColor] paleColor],
             NSLocalizedString(@"uk", nil):      [[UIColor brownColor] paleColor]};
}

+ (NSDictionary * _Nonnull)typeColors {
    
    return @{NSLocalizedString(WOTApiTankType.at_spg, nil):       [[UIColor blueColor] paleColor],
             NSLocalizedString(WOTApiTankType.spg, nil):          [[UIColor brownColor] paleColor],
             NSLocalizedString(WOTApiTankType.lightTank, nil):   [[UIColor greenColor] paleColor],
             NSLocalizedString(WOTApiTankType.mediumTank, nil):  [[UIColor yellowColor] paleColor],
             NSLocalizedString(WOTApiTankType.heavyTank, nil):   [[UIColor redColor] paleColor]};
}

@end

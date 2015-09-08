//
//  WOTNode+PivotFactory.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+PivotFactory.h"
#import "WOTPivotColNode.h"
#import "WOTPivotRowNode.h"
#import "WOTPivotFilterNode.h"
#import "WOTPivotColNode.h"
#import "WOTPivotDataNode.h"
#import "Tanks.h"

@implementation WOTNode (PivotFactory)

+ (Class)pivotNodeClassForType:(PivotMetadataType)type {

    Class result;
    switch (type) {
            
        case PivotMetadataTypeColumn:
            
            result = [WOTPivotColNode class];
            break;
        case PivotMetadataTypeFilter:
            
            result = [WOTPivotFilterNode class];
            break;
        case PivotMetadataTypeData:
            
            result = [WOTPivotDataNode class];
            break;
        case PivotMetadataTypeRow:
            
            result = [WOTPivotRowNode class];
            break;
        default:
            break;
    }
    return result;
}

+ (WOTPivotNode *)pivotDataNodeForPredicate:(NSPredicate *)predicate andTanksObject:(id)tanksObject {
    
    Tanks *tanks = tanksObject;
    NSURL *imageURL = [NSURL URLWithString:tanks.image];
    WOTPivotNode *node = [[WOTPivotDataNode alloc] initWithName:tanks.short_name_i18n imageURL:imageURL predicate:predicate];
    
    node.dataColor = [UIColor whiteColor];
    NSDictionary *colors = [WOTNode typeColors];
    
    node.dataColor = colors[tanks.type];
    
    [node setData1:tanks];
    return node;
}


+ (WOTPivotNode *)pivotDPMMetadataItemAsType:(PivotMetadataType)type {
    
    Class PivotNodeClass = [self pivotNodeClassForType:type];

    WOTPivotNode *result = [[PivotNodeClass alloc] initWithName:@"DPM" predicate:nil];
    
    NSCompoundPredicate *predicateLess500 =             [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(500)]]];
    NSCompoundPredicate *predicateGreat500Less1000 =    [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(500)],
                                                                                                             [NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(1000)]]];
    NSCompoundPredicate *predicateGreat1000Less1500 =   [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(1000)],
                                                                                                             [NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(1500)]]];
    NSCompoundPredicate *predicateGreat1500Less2000 =   [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(1500)],
                                                                                                             [NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(2000)]]];
    NSCompoundPredicate *predicateGreat2000 =           [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(2000)]]];
    
    [result addChild:[[PivotNodeClass alloc] initWithName:@"[0;500)"       predicate:predicateLess500]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"[500;1000)"    predicate:predicateGreat500Less1000]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"[1000;1500)"   predicate:predicateGreat1000Less1500]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"[1500;2000)"   predicate:predicateGreat1500Less2000]];
    [result addChild:[[PivotNodeClass alloc] initWithName:@"2000+"         predicate:predicateGreat2000]];
    
    return result;
}

+ (WOTPivotNode *)pivotNationMetadataItemAsType:(PivotMetadataType)type {
    
    Class PivotNodeClass = [self pivotNodeClassForType:type];
    WOTPivotNode *result = [[PivotNodeClass alloc] initWithName:@"Nation" predicate:nil];
    
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_CHINA)   predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_CHINA]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_CZECH)   predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_CZECH]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_FRANCE)  predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_FRANCE]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_GERMANY) predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_GERMANY]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_JAPAN)   predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_JAPAN]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_UK)      predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_UK]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_USA)     predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_USA]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_NATION_USSR)    predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_USSR]]];
    
    return result;
}

+ (WOTPivotNode *)pivotTierMetadataItemAsType:(PivotMetadataType)type {
    
    Class PivotNodeClass = [self pivotNodeClassForType:type];
    WOTPivotNode *result = [[PivotNodeClass alloc] initWithName:@"Tier" predicate:nil];
    
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_1)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_1]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_2)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_2]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_3)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_3]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_4)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_4]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_5)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_5]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_6)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_6]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_7)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_7]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_8)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_8]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_9)  predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_9]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LEVEL_10) predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_10]]];
    
    return result;
}

+ (WOTPivotNode *)pivotPremiumMetadataItemAsType:(PivotMetadataType)type {
    
    Class PivotNodeClass = [self pivotNodeClassForType:type];
    WOTPivotNode *result = [[PivotNodeClass alloc] initWithName:@"Premium" predicate:nil];
    
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_IS_PREMIUM)     predicate:[NSPredicate predicateWithFormat:@"%K == YES", WOT_KEY_IS_PREMIUM]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_IS_NOT_PREMIUM) predicate:[NSPredicate predicateWithFormat:@"%K == NO",  WOT_KEY_IS_PREMIUM]]];
    
    return result;
}

+ (WOTPivotNode *)pivotTypeMetadataItemAsType:(PivotMetadataType)type {
    
    Class PivotNodeClass = [self pivotNodeClassForType:type];
    WOTPivotNode *result = [[PivotNodeClass alloc] initWithName:@"Type" predicate:nil];
    
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_AT_SPG) predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_AT_SPG]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_LT)     predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_LIGHT_TANK]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_HT)     predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_HEAVY_TANK]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_MT)     predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_MEDIUM_TANK]]];
    [result addChild:[[PivotNodeClass alloc] initWithName:WOTString(WOT_STRING_SPG)    predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_SPG]]];
    
    return result;
}

+ (NSDictionary *)nationColors {
    
    return @{WOT_STRING_NATION_USA:     [[UIColor purpleColor] paleColor],
             WOT_STRING_NATION_USSR:    [[UIColor redColor] paleColor],
             WOT_STRING_NATION_JAPAN:   [[UIColor orangeColor] paleColor],
             WOT_STRING_NATION_CHINA:   [[UIColor yellowColor] paleColor],
             WOT_STRING_NATION_GERMANY: [[UIColor brownColor] paleColor],
             WOT_STRING_NATION_FRANCE:  [[UIColor greenColor] paleColor],
             WOT_STRING_NATION_CZECH:   [[UIColor cyanColor] paleColor],
             WOT_STRING_NATION_UK:      [[UIColor blueColor] paleColor]};
}

+ (NSDictionary *)typeColors {
    
    return @{WOT_STRING_TANK_TYPE_AT_SPG:       [[UIColor blueColor] paleColor],
             WOT_STRING_TANK_TYPE_SPG:          [[UIColor brownColor] paleColor],
             WOT_STRING_TANK_TYPE_LIGHT_TANK:   [[UIColor greenColor] paleColor],
             WOT_STRING_TANK_TYPE_MEDIUM_TANK:  [[UIColor yellowColor] paleColor],
             WOT_STRING_TANK_TYPE_HEAVY_TANK:   [[UIColor redColor] paleColor]};
}

@end

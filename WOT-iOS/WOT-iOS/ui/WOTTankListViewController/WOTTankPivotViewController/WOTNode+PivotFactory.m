//
//  WOTNode+PivotFactory.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+PivotFactory.h"

@implementation WOTNode (PivotFactory)

+ (WOTPivotNode *)pivotDPMMetadataItemAsType:(PivotMetadataType)type {

    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:@"DPM" pivotMetadataType:type predicate:nil];
    
    NSCompoundPredicate *predicateLess500 =             [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(500)]]];
    NSCompoundPredicate *predicateGreat500Less1000 =    [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(500)],
                                                                                                             [NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(1000)]]];
    NSCompoundPredicate *predicateGreat1000Less1500 =   [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(1000)],
                                                                                                             [NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(1500)]]];
    NSCompoundPredicate *predicateGreat1500Less2000 =   [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(1500)],
                                                                                                             [NSPredicate predicateWithFormat:@"%K < %@", WOT_KEY_DPM, @(2000)]]];
    NSCompoundPredicate *predicateGreat2000 =           [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%K >= %@", WOT_KEY_DPM, @(2000)]]];
    
    [result addChild:[[WOTPivotNode alloc] initWithName:@"[0;500)"       pivotMetadataType:type predicate:predicateLess500]];
    [result addChild:[[WOTPivotNode alloc] initWithName:@"[500;1000)"    pivotMetadataType:type predicate:predicateGreat500Less1000]];
    [result addChild:[[WOTPivotNode alloc] initWithName:@"[1000;1500)"   pivotMetadataType:type predicate:predicateGreat1000Less1500]];
    [result addChild:[[WOTPivotNode alloc] initWithName:@"[1500;2000)"   pivotMetadataType:type predicate:predicateGreat1500Less2000]];
    [result addChild:[[WOTPivotNode alloc] initWithName:@"2000+"         pivotMetadataType:type predicate:predicateGreat2000]];
    
    return result;
}

+ (WOTPivotNode *)pivotNationMetadataItemAsType:(PivotMetadataType)type {
    
    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:@"Nation" pivotMetadataType:type predicate:nil];
    
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_CHINA)   pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_CHINA]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_FRANCE)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_FRANCE]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_GERMANY) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_GERMANY]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_JAPAN)   pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_JAPAN]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_UK)      pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_UK]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_USA)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_USA]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_NATION_USSR)    pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_NATION, WOT_STRING_NATION_USSR]]];
    
    return result;
}

+ (WOTPivotNode *)pivotTierMetadataItemAsType:(PivotMetadataType)type {
    
    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:@"Tier" pivotMetadataType:type predicate:nil];
    
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_1)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_1]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_2)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_2]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_3)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_3]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_4)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_4]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_5)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_5]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_6)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_6]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_7)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_7]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_8)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_8]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_9)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_9]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_10) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %d", WOT_KEY_LEVEL, WOT_INTEGER_LEVEL_10]]];
    
    return result;
}

+ (WOTPivotNode *)pivotPremiumMetadataItemAsType:(PivotMetadataType)type {
    
    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:@"Premium" pivotMetadataType:type predicate:nil];
    
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_IS_PREMIUM)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == YES", WOT_KEY_IS_PREMIUM]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_IS_NOT_PREMIUM) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == NO",  WOT_KEY_IS_PREMIUM]]];
    
    return result;
}

+ (WOTPivotNode *)pivotTypeMetadataItemAsType:(PivotMetadataType)type {
    
    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:@"Type" pivotMetadataType:type predicate:nil];
    
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_AT_SPG) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_AT_SPG]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_LT)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_LIGHT_TANK]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_HT)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_HEAVY_TANK]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_MT)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_MEDIUM_TANK]]];
    [result addChild:[[WOTPivotNode alloc] initWithName:WOTString(WOT_STRING_SPG)    pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == %@", WOT_KEY_TYPE, WOT_STRING_TANK_TYPE_SPG]]];
    
    return result;
}

+ (NSDictionary *)nationColors {
    
    return @{WOT_STRING_NATION_USA:     [[UIColor purpleColor] paleColor],
             WOT_STRING_NATION_USSR:    [[UIColor redColor] paleColor],
             WOT_STRING_NATION_JAPAN:   [[UIColor orangeColor] paleColor],
             WOT_STRING_NATION_CHINA:   [[UIColor yellowColor] paleColor],
             WOT_STRING_NATION_GERMANY: [[UIColor brownColor] paleColor],
             WOT_STRING_NATION_FRANCE:  [[UIColor greenColor] paleColor],
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

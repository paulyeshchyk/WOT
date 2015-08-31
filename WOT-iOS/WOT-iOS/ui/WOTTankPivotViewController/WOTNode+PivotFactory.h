//
//  WOTNode+PivotFactory.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotNode.h"

typedef NS_ENUM(NSInteger, PivotMetadataType) {
    PivotMetadataTypeUnknown = 0,
    PivotMetadataTypeFilter,
    PivotMetadataTypeColumn,
    PivotMetadataTypeRow,
    PivotMetadataTypeData
};

@interface WOTNode (PivotFactory)

+ (Class)pivotNodeClassForType:(PivotMetadataType)type;

+ (WOTPivotNode *)pivotDataNodeForPredicate:(NSPredicate *)predicate andTanksObject:(id)tanksObject;

+ (WOTPivotNode *)pivotNationMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotTierMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotPremiumMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotTypeMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotDPMMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary *)nationColors;
+ (NSDictionary *)typeColors;

@end

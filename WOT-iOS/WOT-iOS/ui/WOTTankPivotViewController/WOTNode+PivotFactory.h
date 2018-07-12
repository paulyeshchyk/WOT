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

+ (id<WOTNodeProtocol>)pivotDataNodeForPredicate:(NSPredicate *)predicate andTanksObject:(id)tanksObject;

+ (id<WOTNodeProtocol>)pivotNationMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTNodeProtocol>)pivotTierMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTNodeProtocol>)pivotPremiumMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTNodeProtocol>)pivotTypeMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTNodeProtocol>)pivotDPMMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary *)nationColors;
+ (NSDictionary *)typeColors;

@end

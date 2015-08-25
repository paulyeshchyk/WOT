//
//  WOTNode+PivotFactory.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode (PivotFactory)

+ (WOTNode *)pivotNationMetadataItemAsType:(PivotMetadataType)type;
+ (WOTNode *)pivotTierMetadataItemAsType:(PivotMetadataType)type;
+ (WOTNode *)pivotPremiumMetadataItemAsType:(PivotMetadataType)type;
+ (WOTNode *)pivotTypeMetadataItemAsType:(PivotMetadataType)type;
+ (WOTNode *)pivotDPMMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary *)nationColors;
+ (NSDictionary *)typeColors;

@end

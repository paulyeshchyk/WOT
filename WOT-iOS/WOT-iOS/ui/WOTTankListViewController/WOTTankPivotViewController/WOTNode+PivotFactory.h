//
//  WOTNode+PivotFactory.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotNode.h"


@interface WOTNode (PivotFactory)

+ (WOTPivotNode *)pivotNationMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotTierMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotPremiumMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotTypeMetadataItemAsType:(PivotMetadataType)type;
+ (WOTPivotNode *)pivotDPMMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary *)nationColors;
+ (NSDictionary *)typeColors;

@end

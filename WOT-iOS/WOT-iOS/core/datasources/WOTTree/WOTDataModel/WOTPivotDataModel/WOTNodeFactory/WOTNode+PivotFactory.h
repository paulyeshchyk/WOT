//
//  WOTNode+PivotFactory.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOTEnums.h"

@protocol WOTPivotNodeProtocol;

@interface WOTNodeFactory: NSObject

+ (Class)pivotNodeClassForType:(PivotMetadataType)type;

+ (id<WOTPivotNodeProtocol>)pivotDataNodeForPredicate:(NSPredicate *)predicate andTanksObject:(id)tanksObject;

+ (id<WOTPivotNodeProtocol>)pivotNationMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol>)pivotTierMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol>)pivotPremiumMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol>)pivotTypeMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol>)pivotDPMMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary *)nationColors;
+ (NSDictionary *)typeColors;

@end

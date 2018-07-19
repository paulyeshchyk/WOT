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

+ (Class _Nonnull)pivotNodeClassForType:(PivotMetadataType)type;

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotDataNodeForPredicate:(NSPredicate * _Nonnull)predicate andTanksObject:(id _Nonnull)tanksObject;

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotNationMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotTierMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotPremiumMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotTypeMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotDPMMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary * _Nonnull)nationColors;
+ (NSDictionary * _Nonnull)typeColors;

@end

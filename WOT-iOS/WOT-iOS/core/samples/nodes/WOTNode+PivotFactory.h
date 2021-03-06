//
//  WOTNode+PivotFactory.h
//  WOT-iOS
//
//  Created on 8/25/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WOTPivot/WOTPivot.h>

@protocol WOTPivotNodeProtocol;

@interface WOTNodeFactory: NSObject

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotEmptyNode;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotDataNodeForPredicate:(NSPredicate * _Nullable)predicate andVehicle:(id _Nonnull)vehicle;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotDataNodeGroupForPredicate:(NSPredicate * _Nullable)predicate andTanksObjects:(NSArray* _Nonnull)tanksObjects;

+ (id<WOTPivotNodeProtocol> _Nonnull)pivotHPMetadataItemAsType:(PivotMetadataType)type;
+ (id<WOTPivotNodeProtocol> _Nonnull)pivotWeightMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary * _Nonnull)nationColors;
+ (NSDictionary * _Nonnull)typeColors;

@end

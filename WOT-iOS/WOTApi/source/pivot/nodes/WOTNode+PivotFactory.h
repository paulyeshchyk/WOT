//
//  WOTNode+PivotFactory.h
//  WOT-iOS
//
//  Created on 8/25/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WOTPivot/WOTPivot.h>

@protocol PivotNodeProtocol;

@interface WOTNodeFactory: NSObject

+ (id<PivotNodeProtocol> _Nonnull)pivotEmptyNode;
+ (id<PivotNodeProtocol> _Nonnull)pivotDataNodeForPredicate:(NSPredicate * _Nullable)predicate andVehicle:(id _Nonnull)vehicle;
+ (id<PivotNodeProtocol> _Nonnull)pivotDataNodeGroupForPredicate:(NSPredicate * _Nullable)predicate andTanksObjects:(NSArray* _Nonnull)tanksObjects;

+ (id<PivotNodeProtocol> _Nonnull)pivotHPMetadataItemAsType:(PivotMetadataType)type;
+ (id<PivotNodeProtocol> _Nonnull)pivotWeightMetadataItemAsType:(PivotMetadataType)type;

+ (NSDictionary * _Nonnull)nationColors;
+ (NSDictionary * _Nonnull)typeColors;

@end

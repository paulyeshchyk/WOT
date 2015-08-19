//
//  WOTNode+Pivot.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

typedef NS_ENUM(NSInteger, PivotMetadataType) {
    PivotMetadataTypeUnknown = 0,
    PivotMetadataTypeFilter,
    PivotMetadataTypeColumn,
    PivotMetadataTypeRow,
    PivotMetadataTypeData
};

@interface WOTNode (Pivot)

- (id)initWithName:(NSString *)name pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate;

- (void)setPredicate:(NSPredicate *)predicate;
- (NSPredicate *)predicate;

- (void)setPivotMetadataType:(PivotMetadataType)pivotMetadataType;
- (PivotMetadataType)pivotMetadataType;

- (void)setData:(id<NSCopying>)data;
- (id<NSCopying>)data;

- (void)addStepParentsFromArray:(NSArray *)stepParents;

@end

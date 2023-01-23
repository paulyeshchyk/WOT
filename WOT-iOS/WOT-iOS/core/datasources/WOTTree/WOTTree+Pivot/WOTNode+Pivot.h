//
//  WOTNode+Pivot.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"
#import "WOTTree+Pivot.h"

typedef NS_ENUM(NSInteger, PivotMetadataType) {
    PivotMetadataTypeUnknown = 0,
    PivotMetadataTypeFilter,
    PivotMetadataTypeColumn,
    PivotMetadataTypeRow,
    PivotMetadataTypeData
};

@interface WOTNode (Pivot)

@property (nonatomic, readonly)CGRect relativeRect;
@property (nonatomic) NSPredicate *predicate;
@property (nonatomic) PivotMetadataType pivotMetadataType;
@property (nonatomic) id<NSCopying> data;
@property (nonatomic) NSInteger index;
@property (nonatomic) WOTNode *stepParentColumn;
@property (nonatomic) WOTNode *stepParentRow;
@property (nonatomic) NSInteger indexInsideStepParentColumn;
@property (nonatomic) WOTTree *tree;
@property (nonatomic) PivotStickyType stickyType;
@property (nonatomic) UIColor *dataColor;

- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate;
- (id)initWithName:(NSString *)name pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate;
- (id)initWithName:(NSString *)name tree:(WOTTree *)tree isVisible:(BOOL)isVisible;

- (void)setMaxWidth:(NSInteger)width forKey:(id)key;
- (NSInteger)maxWidthOrValue:(NSInteger)value;

@end

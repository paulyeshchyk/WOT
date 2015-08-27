//
//  WOTPivotNode.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"
#import "WOTPivotDimensionProtocol.h"

typedef NS_ENUM(NSInteger, PivotMetadataType) {
    PivotMetadataTypeUnknown = 0,
    PivotMetadataTypeFilter,
    PivotMetadataTypeColumn,
    PivotMetadataTypeRow,
    PivotMetadataTypeData
};

@interface WOTPivotNode : WOTNode

@property (nonatomic, strong) UIColor *dataColor;
@property (nonatomic, strong) NSManagedObject *data1;
@property (nonatomic, readonly) CGRect relativeRect;
@property (nonatomic, readonly) PivotStickyType stickyType;
@property (nonatomic, assign) PivotMetadataType pivotMetadataType;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) WOTPivotNode *stepParentColumn;
@property (nonatomic, strong) WOTPivotNode *stepParentRow;
@property (nonatomic, strong) NSDictionary *sizesMap;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger indexInsideStepParentColumn;
@property (nonatomic, assign) id<WOTPivotDimensionProtocol> dimensionDelegate;

- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate;
- (id)initWithName:(NSString *)name pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate;
- (id)initWithName:(NSString *)name dimensionDelegate:(id<WOTPivotDimensionProtocol>)dimensionDelegate isVisible:(BOOL)isVisible;

- (void)setMaxWidth:(NSInteger)width forKey:(id)key;
- (NSInteger)maxWidthOrValue:(NSInteger)value;

@end

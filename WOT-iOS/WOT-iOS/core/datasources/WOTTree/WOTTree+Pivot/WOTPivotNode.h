//
//  WOTPivotNode.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"
#import "WOTPivotDimensionProtocol.h"
#import "WOTEnums.h"
#import <CoreData/CoreData.h>

@interface WOTPivotNode : WOTNode

@property (nonatomic, strong) UIColor *dataColor;
@property (nonatomic, strong) NSManagedObject *data1;
@property (nonatomic, readonly) CGRect relativeRect;
@property (nonatomic, readonly) PivotStickyType stickyType;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) WOTPivotNode *stepParentColumn;
@property (nonatomic, strong) WOTPivotNode *stepParentRow;
@property (nonatomic, strong) NSDictionary *sizesMap;
@property (nonatomic, assign) NSInteger indexInsideStepParentColumn;
@property (nonatomic, assign) id<WOTPivotDimensionProtocol> dimensionDelegate;

@property (nonatomic, readonly)NSInteger x;
@property (nonatomic, readonly)NSInteger y;
@property (nonatomic, readonly)NSInteger width;
@property (nonatomic, readonly)NSInteger height;

+ (NSInteger)childrenMaxWidthForSiblingNode:(WOTNode *)node orValue:(NSInteger)value;

- (id)initWithName:(NSString *)name predicate:(NSPredicate *)predicate;
- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL predicate:(NSPredicate *)predicate ;
- (id)initWithName:(NSString *)name dimensionDelegate:(id<WOTPivotDimensionProtocol>)dimensionDelegate isVisible:(BOOL)isVisible;
- (id)copyWithPredicate:(NSPredicate *)predicate;

- (void)setMaxWidth:(NSInteger)width forKey:(id)key;
- (NSInteger)maxWidthOrValue:(NSInteger)value;

@end

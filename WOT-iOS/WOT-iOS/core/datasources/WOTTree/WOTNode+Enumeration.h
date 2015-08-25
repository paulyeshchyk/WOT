//
//  WOTNode+Enumeration.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

typedef NSComparisonResult(^HierarchyComparator)(WOTNode *obj1, WOTNode *obj2, id level);

typedef void(^HierarchyEnumarationCallback)(WOTNode *node);

@interface WOTNode (Enumeration)

@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSArray *endpoints;
@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) NSInteger childrenCountForSiblingNode;
@property (nonatomic, readonly) NSInteger parentsCount;
@property (nonatomic, readonly) NSInteger visibleParentsCount;


+ (WOTNode *)endpointForArray:(NSArray *)childArray atIndexPath:(NSIndexPath *)indexPath;
+ (NSArray *)endpointsForArray:(NSArray *)childArray;
+ (NSArray *)allItemsForArray:(NSArray *)childArray;

+ (NSInteger)depthForArray:(NSArray *)array;

+ (void)enumerateItemsHierarchy:(NSArray *)items callback:(HierarchyEnumarationCallback)callback comparator:(HierarchyComparator)comparator;


- (void)enumerateAllChildrenUsingBlock:(HierarchyEnumarationCallback)callback comparator:(HierarchyComparator)comparator;
- (void)enumerateEndpointsUsingBlock:(HierarchyEnumarationCallback)callback;

@end

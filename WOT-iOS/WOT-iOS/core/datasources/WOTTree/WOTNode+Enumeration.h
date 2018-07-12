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

@property (nonatomic, readonly) NSArray *endpoints __deprecated_msg("use WOTEnumerator instead");
@property (nonatomic, readonly) NSArray *allItems;

+ (void)enumerateItemsHierarchy:(NSArray *)items callback:(HierarchyEnumarationCallback)callback comparator:(HierarchyComparator)comparator;
- (void)enumerateAllChildrenUsingBlock:(HierarchyEnumarationCallback)callback comparator:(HierarchyComparator)comparator;

@end

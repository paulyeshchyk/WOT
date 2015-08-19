//
//  WOTTree+Pivot.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree.h"

typedef NSArray *(^PivotItemCreationBlock)(NSArray *stepParents);

@interface WOTTree (Pivot)

- (void)setFilter:(WOTNode *)filter;
- (WOTNode *)filter;

- (void)setColumns:(NSArray *)columns;
- (NSArray *)columns;

- (void)setRows:(NSArray *)rows;
- (NSArray *)rows;


- (void)setPivotItemCreationBlock:(PivotItemCreationBlock)block;

- (void)makePivot;

- (NSInteger)pivotRowsCount;
- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex;
- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGRect)dimensionForNode:(WOTNode *)node;

@end

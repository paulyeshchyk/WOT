//
//  WOTTree+Pivot.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree.h"

typedef NSArray *(^PivotItemCreationBlock)(NSArray *predicates);

@interface WOTTree (Pivot)

@property (nonatomic)WOTNode *rootFiltersNode;
@property (nonatomic)WOTNode *rootColumnsNode;
@property (nonatomic)WOTNode *rootRowsNode;
@property (nonatomic)WOTNode *rootDataNode;
@property (nonatomic)PivotItemCreationBlock pivotItemCreationBlock;

- (void)makePivot;
- (void)addMetadataItems:(NSArray *)metadataItems;

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex;
- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)contentSize;

@end

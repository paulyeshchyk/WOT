//
//  WOTTree+Pivot.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree+Pivot.h"
#import "WOTPivotColumn.h"
#import "WOTPivotRow.h"
#import "WOTNode+Enumeration.h"

#import <objc/runtime.h>

@implementation WOTTree (Pivot)

static const void *PivotFilters = &PivotFilters;
- (void)setFilters:(NSArray *)filters {
    
    objc_setAssociatedObject(self, PivotFilters, filters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)filters {
    
    return objc_getAssociatedObject(self, PivotFilters);
}

static const void *PivotColumns = &PivotColumns;
- (void)setColumns:(NSArray *)columns {
    
    objc_setAssociatedObject(self, PivotColumns, columns, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)columns {
    
    return objc_getAssociatedObject(self, PivotColumns);
}

static const void *PivotRows = &PivotRows;
- (void)setRows:(NSArray *)rows {
    
    objc_setAssociatedObject(self, PivotRows, rows, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)rows {
    
    return objc_getAssociatedObject(self, PivotRows);
}

static const void *PivotItemBlock = &PivotItemBlock;
- (void)setPivotItemCreationBlock:(PivotItemCreationBlock)block {
    
    objc_setAssociatedObject(self, PivotItemBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PivotItemCreationBlock)pivotItemCreationBlock {
    
    return objc_getAssociatedObject(self, PivotItemBlock);
}


static const void *PivotMetadataItems = &PivotMetadataItems;
- (void)setMetadataItems:(NSArray *)metadataItems {
    
    objc_setAssociatedObject(self, PivotMetadataItems, metadataItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)metadataItems {
    
    return objc_getAssociatedObject(self, PivotMetadataItems);
}

static const void *PivotAllItems = &PivotAllItems;
- (void)setAllItems:(NSArray *)allItems {
    
    objc_setAssociatedObject(self, PivotAllItems, allItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)allItems {
    
    return objc_getAssociatedObject(self, PivotAllItems);
}

static const void *PivotDataItems = &PivotDataItems;
- (void)setDataItems:(NSArray *)dataItems {
    
    objc_setAssociatedObject(self, PivotDataItems, dataItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)dataItems {
    
    return objc_getAssociatedObject(self, PivotDataItems);
}


- (void)makePivot {
    
    [self removeAllNodes];
    
    WOTNode *root = [[WOTNode alloc] init];
    [root addChildArray:[self filters]];
    [root addChildArray:[self columns]];
    [root addChildArray:[self rows]];
    [self addNode:root];
    
    [self makeData];
    
    [self reindex];
}

- (void)makeData {
    
    PivotItemCreationBlock block = [self pivotItemCreationBlock];
    
    NSArray *rowsEndPoints = [WOTNode endpointsForArray:[self rows]];
    NSArray *colsEndPoints = [WOTNode endpointsForArray:[self columns]];
    
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
    
    [colsEndPoints enumerateObjectsUsingBlock:^(WOTPivotColumn *columnNode, NSUInteger idx, BOOL *stop) {
        
        [rowsEndPoints enumerateObjectsUsingBlock:^(WOTPivotRow *rowNode, NSUInteger idx, BOOL *stop) {
            
            if (block){
                
                NSArray *nodes = block(@[columnNode, rowNode]);
                [dataItems addObjectsFromArray:nodes];
            }
        }];
    }];
    
    NSMutableArray *metadataItems = [[NSMutableArray alloc] init];
    [metadataItems addObjectsFromArray:[WOTNode allItemsForArray:[self filters]]];
    [metadataItems addObjectsFromArray:[WOTNode allItemsForArray:[self rows]]];
    [metadataItems addObjectsFromArray:[WOTNode allItemsForArray:[self columns]]];
    
    [self setMetadataItems:metadataItems];
    [self setDataItems:dataItems];
    
    NSMutableArray *allItems = [[NSMutableArray alloc] init];
    [allItems addObjectsFromArray:metadataItems];
    [allItems addObjectsFromArray:dataItems];
    [self setAllItems:allItems];
    
}

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex {

    NSInteger allItemsCount = [[self allItems] count];
    
    return allItemsCount;
}

- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath {

    WOTNode *result = [self allItems][indexPath.row];
    return result;
}

- (NSInteger)pivotRowsCount {

    return 1;
}

- (NSInteger)metadataRowsCount {
    
    __block NSInteger filterMaxDepth = 0;
    [[self filters] enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        NSInteger nodeDepth = [node depth];
        filterMaxDepth = MAX(filterMaxDepth, nodeDepth);
    }];
    
    __block NSInteger columnsMaxDepth = 0;
    [[self columns] enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        NSInteger nodeDepth = [node depth];
        columnsMaxDepth = MAX(columnsMaxDepth, nodeDepth);
    }];
    
    NSInteger filterAndColumnsDepth = MAX(filterMaxDepth, columnsMaxDepth);
    return filterAndColumnsDepth;
}

@end

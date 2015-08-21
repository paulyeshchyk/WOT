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
#import "WOTNode+Pivot.h"

#import <objc/runtime.h>

@implementation WOTTree (Pivot)
@dynamic rootFiltersNode;
@dynamic rootColumnsNode;
@dynamic rootRowsNode;
@dynamic rootDataNode;
@dynamic pivotItemCreationBlock;

- (id)init {
    
    self = [super init];
    if (self){
        
        self.rootFiltersNode = [[WOTNode alloc] initWithName:@"root filter" tree:self isVisible:NO];
        self.rootRowsNode = [[WOTNode alloc] initWithName:@"root rows" tree:self isVisible:NO];
        self.rootColumnsNode = [[WOTNode alloc] initWithName:@"root columns" tree:self isVisible:NO];
        self.rootDataNode = [[WOTNode alloc] initWithName:@"root data" tree:self isVisible:NO];

        [self addNode:self.rootFiltersNode];
        [self addNode:self.rootRowsNode];
        [self addNode:self.rootColumnsNode];
        [self addNode:self.rootDataNode];
    }
    return self;
}

- (CGSize)contentSize {

    NSInteger rowNodesDepth = [self.rootRowsNode depth];
    
    __block NSInteger maxWidth = 0;
    [[self.rootColumnsNode endpoints] enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        maxWidth += [node maxWidthOrValue:1];
    }];
    
    NSInteger width = rowNodesDepth + maxWidth;
    
    
    
    NSInteger colNodesDepth = [self.rootColumnsNode depth];
    NSInteger rowNodesEndpointsCount = [[self.rootRowsNode endpoints] count];
    NSInteger height = colNodesDepth + rowNodesEndpointsCount;
    
    return CGSizeMake(width, height);
}

- (void)makePivot {

    [self makeData];
    
    [self reindex];
}

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex {
    
    NSInteger filtersItemsCount = [[self.rootFiltersNode allItems] count];
    NSInteger columnsItemsCount = [[self.rootColumnsNode allItems] count];
    NSInteger rowsItemsCount = [[self.rootRowsNode allItems] count];
    NSInteger dataItemsCount = [[self.rootDataNode allItems] count];
    
    return filtersItemsCount + columnsItemsCount + rowsItemsCount + dataItemsCount;
}

- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTNode *result;
    
    result = [[[self.rootFiltersNode allItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d",indexPath.row]] lastObject];
    if (!result) {
        
        result = [[[self.rootColumnsNode allItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d",indexPath.row]] lastObject];
    }
    
    if (!result) {
        
        result = [[[self.rootRowsNode allItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d",indexPath.row]] lastObject];
    }
    
    if (!result) {
        
        result = [[[self.rootDataNode allItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d",indexPath.row]] lastObject];
    }
    
    if (!result) {
        
        NSCAssert(NO, @"Node not found for indexPath:%@",indexPath);
    }
    
    return result;
}

#pragma mark - getters / setters

static const void *RootDataNodeRef = &RootDataNodeRef;
- (WOTNode *)rootDataNode {
    
    return objc_getAssociatedObject(self, RootDataNodeRef);
}

- (void)setRootDataNode:(WOTNode *)node {
    
    objc_setAssociatedObject(self, RootDataNodeRef, node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *RootColumnsNodeRef = &RootColumnsNodeRef;
- (WOTNode *)rootColumnsNode {
    
    return objc_getAssociatedObject(self, RootColumnsNodeRef);
}

- (void)setRootColumnsNode:(WOTNode *)node {
    
    objc_setAssociatedObject(self, RootColumnsNodeRef, node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *RootRowsNodeRef = &RootRowsNodeRef;
- (WOTNode *)rootRowsNode {
    
    return objc_getAssociatedObject(self, RootRowsNodeRef);
}

- (void)setRootRowsNode:(WOTNode *)node {
    
    objc_setAssociatedObject(self, RootRowsNodeRef, node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *RootFilterNodeRef = &RootFilterNodeRef;
- (WOTNode *)rootFiltersNode {
    
    return objc_getAssociatedObject(self, RootFilterNodeRef);
}

- (void)setRootFiltersNode:(WOTNode *)node {
    
    objc_setAssociatedObject(self, RootFilterNodeRef, node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *PivotItemBlock = &PivotItemBlock;
- (void)setPivotItemCreationBlock:(PivotItemCreationBlock)block {
    
    objc_setAssociatedObject(self, PivotItemBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PivotItemCreationBlock)pivotItemCreationBlock {
    
    return objc_getAssociatedObject(self, PivotItemBlock);
}

#pragma mark - private
- (void)makeData {
    
    __block NSInteger index = 0;
    
    [self.rootFiltersNode enumerateAllChildrenUsingBlock:^(WOTNode *node) {
        
        [node setIndex:index];
        index++;
    }];

    [self.rootColumnsNode enumerateAllChildrenUsingBlock:^(WOTNode *node) {
        
        [node setIndex:index];
        index++;
    }];
    
    [self.rootRowsNode enumerateAllChildrenUsingBlock:^(WOTNode *rowNode) {

        [rowNode setIndex:index];
        index++;

        if (rowNode.predicate) {
        
            if (self.pivotItemCreationBlock) {
                
                [self.rootColumnsNode enumerateEndpointsUsingBlock:^(WOTNode *columnNode) {

                    NSMutableArray *predicates = [[NSMutableArray alloc] init];
                    if (columnNode.predicate) [predicates addObject:columnNode.predicate];
                    if (rowNode.predicate) [predicates addObject:rowNode.predicate];

                    NSArray *dataNodes = self.pivotItemCreationBlock(predicates);

                    [columnNode setMaxWidth:dataNodes.count forKey:@(rowNode.hash)];
                    [rowNode setMaxWidth:dataNodes.count forKey:@(columnNode.hash)];
                    
                    [dataNodes enumerateObjectsUsingBlock:^(WOTNode *dataNode, NSUInteger idx, BOOL *stop) {
                        
                        [dataNode setIndex:index];
                        index++;
                        
                        [dataNode setStepParentColumn:columnNode];
                        [dataNode setStepParentRow:rowNode];
                        [dataNode setIndexInsideStepParentColumn:idx];
                        
                        [self.rootDataNode addChild:dataNode];
                    }];
                }];
            }
        }
    }];
}

@end

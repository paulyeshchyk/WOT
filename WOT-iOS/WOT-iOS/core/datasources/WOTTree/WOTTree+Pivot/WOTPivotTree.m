//
//  WOTPivotTree.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotTree.h"

#import "WOTPivotNode.h"
#import "WOTNode+Enumeration.h"

@interface WOTPivotTree()

@property (nonatomic, strong) NSMutableArray *metadataItems;
@property (nonatomic, strong) NSDictionary *largeIndex;
@property (nonatomic, strong) WOTNode *rootFiltersNode;
@property (nonatomic, strong) WOTNode *rootColumnsNode;
@property (nonatomic, strong) WOTNode *rootRowsNode;
@property (nonatomic, strong) WOTNode *rootDataNode;

@end

@implementation WOTPivotTree

@dynamic rootNodeHeight;
@dynamic rootNodeWidth;
@dynamic contentSize;

- (id)init {
    
    self = [super init];
    if (self){
        
        self.rootFiltersNode = [[WOTPivotNode alloc] initWithName:@"root filter" dimensionDelegate:self isVisible:NO];
        self.rootRowsNode = [[WOTPivotNode alloc] initWithName:@"root rows" dimensionDelegate:self isVisible:NO];
        self.rootColumnsNode = [[WOTPivotNode alloc] initWithName:@"root columns" dimensionDelegate:self isVisible:NO];
        self.rootDataNode = [[WOTPivotNode alloc] initWithName:@"root data" dimensionDelegate:self isVisible:NO];
        
        [self addNode:self.rootFiltersNode];
        [self addNode:self.rootRowsNode];
        [self addNode:self.rootColumnsNode];
        [self addNode:self.rootDataNode];
    }
    return self;
}

- (void)dealloc {
    
    [self.rootDataNode removeAllNodesWithCompletionBlock:^(WOTNode *node) {

        [(WOTPivotNode *)node setDimensionDelegate:nil];
    }];
    [self.rootRowsNode removeAllNodesWithCompletionBlock:^(WOTNode *node) {

        [(WOTPivotNode *)node setDimensionDelegate:nil];
    }];
    [self.rootColumnsNode removeAllNodesWithCompletionBlock:^(WOTNode *node) {

        [(WOTPivotNode *)node setDimensionDelegate:nil];
    }];
    [self.rootFiltersNode removeAllNodesWithCompletionBlock:^(WOTNode *node) {

        [(WOTPivotNode *)node setDimensionDelegate:nil];
    }];
    [self setLargeIndex:nil];
}

- (void)addMetadataItems:(NSArray *)metadataItems {
    
    NSMutableArray *selfMetadataItems = [self metadataItems];
    if (!selfMetadataItems) {
        
        selfMetadataItems = [[NSMutableArray alloc] init];
        [self setMetadataItems:selfMetadataItems];
    }
    
    [selfMetadataItems addObjectsFromArray:metadataItems];
}

- (void)resortMetadata {
    
    NSArray *rows = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pivotMetadataType == %d",PivotMetadataTypeRow]];
    [self.rootRowsNode addChildArray:rows];
    
    NSArray *cols = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pivotMetadataType == %d",PivotMetadataTypeColumn]];
    [self.rootColumnsNode addChildArray:cols];
    
    NSArray *filters = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pivotMetadataType == %d",PivotMetadataTypeFilter]];
    [self.rootFiltersNode addChildArray:filters];
}

- (void)makePivot {
    
    [self resortMetadata];
    
    [self makeData];
    
    [self makeIndex];
}

- (void)makeIndex {
    
    [self setLargeIndex:nil];
    NSMutableDictionary *largeIndex = [[NSMutableDictionary alloc] init];
    
    [[self.rootFiltersNode allItems] enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        
        largeIndex[@(node.index)] = node;
    }];
    
    [[self.rootColumnsNode allItems] enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        
        largeIndex[@(node.index)] = node;
    }];
    
    [[self.rootRowsNode allItems] enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        
        largeIndex[@(node.index)] = node;
    }];
    
    [[self.rootDataNode allItems] enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        
        largeIndex[@(node.index)] = node;
    }];
    
    [self setLargeIndex:largeIndex];
}

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex {
    
    /*
     * TODO: be sure rowIndex is used
     * i.e. for case when two or more section displayed
     *
     * currently not used
     */

    return [[[self largeIndex] allKeys] count];
}

- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTNode *result = [self largeIndex][@(indexPath.row)];
    if (!result) {
        
        NSCAssert(NO, @"Node not found for indexPath:%@",indexPath);
    }
    
    return result;
}

#pragma mark - PivotDimensionDelegate
- (NSInteger)rootNodeWidth {
    
    return  self.rootRowsNode.depth;
}

- (NSInteger)rootNodeHeight {
    
    return self.rootColumnsNode.depth;
}

- (CGSize)contentSize {
    
    NSInteger rowNodesDepth = self.rootNodeWidth;
    NSInteger colNodesDepth = self.rootNodeHeight;
    
    __block NSInteger maxWidth = 0;
    [[self.rootColumnsNode endpoints] enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        
        maxWidth += [node maxWidthOrValue:1];
    }];
    
    NSInteger width = rowNodesDepth + maxWidth;
    
    NSInteger rowNodesEndpointsCount = [[self.rootRowsNode endpoints] count];
    NSInteger height = colNodesDepth + rowNodesEndpointsCount;
    
    return CGSizeMake(width, height);
}

#pragma mark - private
- (void)makeData {
    
    __block NSInteger index = 0;
    
    [self.rootFiltersNode enumerateAllChildrenUsingBlock:^(WOTNode *node) {
        
        [(WOTPivotNode *)node setIndex:index];
        [(WOTPivotNode *)node setDimensionDelegate:self];
        index++;
    } comparator:^NSComparisonResult(WOTNode *obj1, WOTNode *obj2, id level) {
        
        return NSOrderedSame;
    }];
    
    [self.rootColumnsNode enumerateAllChildrenUsingBlock:^(WOTNode *node) {
        
        [(WOTPivotNode *)node setIndex:index];
        [(WOTPivotNode *)node setDimensionDelegate:self];
        index++;
    } comparator:^NSComparisonResult(WOTNode *obj1, WOTNode *obj2, id level) {
        
        return [[obj1 name] compare:[obj2 name]];
    }];
    
    [self.rootRowsNode enumerateAllChildrenUsingBlock:^(WOTNode *node) {
        
        [(WOTPivotNode *)node setIndex:index];
        [(WOTPivotNode *)node setDimensionDelegate:self];
        index++;
    } comparator:^NSComparisonResult(WOTNode *obj1, WOTNode *obj2, id level) {
        
        return [[[(WOTPivotNode *)obj1 predicate] predicateFormat] compare:[[(WOTPivotNode *)obj2 predicate] predicateFormat]];
    }];
    
    [self.rootRowsNode enumerateEndpointsUsingBlock:^(WOTNode *rNode) {

        WOTPivotNode *rowNode = (WOTPivotNode *)rNode;
        if ([rowNode predicate]) {
            
            if (self.pivotItemCreationBlock) {
                
                [self.rootColumnsNode enumerateEndpointsUsingBlock:^(WOTNode *cnode) {
                    
                    WOTPivotNode *columnNode = (WOTPivotNode *)cnode;
                    NSMutableArray *predicates = [[NSMutableArray alloc] init];
                    if (columnNode.predicate) [predicates addObject:columnNode.predicate];
                    if (rowNode.predicate) [predicates addObject:rowNode.predicate];
                    [[self.rootFiltersNode endpoints] enumerateObjectsUsingBlock:^(WOTNode *fnode, NSUInteger idx, BOOL *stop) {

                        WOTPivotNode *filterNode = (WOTPivotNode *)fnode;
                        if (filterNode.predicate) {
                            
                            [predicates addObject:filterNode.predicate];
                        }
                    }];
                    
                    NSArray *dataNodes = self.pivotItemCreationBlock(predicates);
                    
                    [columnNode setMaxWidth:dataNodes.count forKey:@(rowNode.hash)];
                    [rowNode setMaxWidth:dataNodes.count forKey:@(columnNode.hash)];
                    
                    [dataNodes enumerateObjectsUsingBlock:^(WOTNode *dnode, NSUInteger idx, BOOL *stop) {

                        WOTPivotNode *dataNode = (WOTPivotNode *)dnode;
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

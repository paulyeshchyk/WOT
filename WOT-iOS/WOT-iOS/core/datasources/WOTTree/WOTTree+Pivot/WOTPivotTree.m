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


#import "WOTPivotColNode.h"
#import "WOTPivotRowNode.h"
#import "WOTPivotFilterNode.h"
#import "WOTPivotColNode.h"
#import "WOTPivotDataNode.h"


@interface WOTPivotTree()

@property (nonatomic, strong) NSMutableArray *metadataItems;
@property (nonatomic, strong) NSDictionary *largeIndex;
@property (nonatomic, strong) WOTNode *rootFiltersNode;
@property (nonatomic, strong) WOTNode *rootColumnsNode;
@property (nonatomic, strong) WOTNode *rootRowsNode;
@property (nonatomic, strong) WOTNode *rootDataNode;
@property (nonatomic, assign)BOOL shouldDisplayEmptyColumns;

@end

@implementation WOTPivotTree

@dynamic rootNodeHeight;
@dynamic rootNodeWidth;
@dynamic contentSize;

- (id)init {
    
    self = [super init];
    if (self){

        self.shouldDisplayEmptyColumns = NO;
    }
    return self;
}

- (void)dealloc {
    
    [self clearMetadataItems];
}

- (WOTPivotNode *)newRootNode:(NSString *)name {
    
    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:name dimensionDelegate:self isVisible:NO];
    [self addNode:result];
    return result;
}

- (void)addMetadataItems:(NSArray *)metadataItems {
    
    NSMutableArray *selfMetadataItems = [self metadataItems];
    if (!selfMetadataItems) {
        
        selfMetadataItems = [[NSMutableArray alloc] init];
        [self setMetadataItems:selfMetadataItems];
    }
    
    [selfMetadataItems addObjectsFromArray:metadataItems];
}

- (void)clearMetadataItems {

    [self setLargeIndex:nil];
    [self removeAllNodes];
    [self.metadataItems removeAllObjects];
    
}

- (void)resortMetadata {
    
    self.rootDataNode = [self newRootNode:@"root data"];

    self.rootRowsNode = [self newRootNode:@"root rows"];
    NSArray *rows = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class == %@",[WOTPivotRowNode class]]];
    [self.rootRowsNode addChildArray:rows];
    
    self.rootColumnsNode = [self newRootNode:@"root columns"];
    NSArray *cols = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class == %@",[WOTPivotColNode class]]];
    [self.rootColumnsNode addChildArray:cols];
    
    self.rootFiltersNode = [self newRootNode:@"root filter"];
    NSArray *filters = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class == %@",[WOTPivotFilterNode class]]];
    [self.rootFiltersNode addChildArray:filters];
}

- (void)makePivot {
    
    [self removeAllNodes];
    
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
    id<WOTNodeProtocol> node = self.rootRowsNode;
    return [WOTNodeEnumerator.sharedInstance depthForChildren: node.children initialLevel: node.isVisible?1:0];
}

- (NSInteger)rootNodeHeight {    
    id<WOTNodeProtocol> node = self.rootColumnsNode;
    return [WOTNodeEnumerator.sharedInstance depthForChildren: node.children initialLevel: node.isVisible?1:0];
}

- (CGSize)contentSize {
    
    NSInteger rowNodesDepth = self.rootNodeWidth;
    NSInteger colNodesDepth = self.rootNodeHeight;
    
#warning emptyDataColumnWidth should be refactored
    NSInteger emptyDataColumnWidth = self.shouldDisplayEmptyColumns ? 1 : 0;

    NSArray * columnEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootColumnsNode];

    __block NSInteger maxWidth = 0;
    [columnEndpoints enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        
        NSInteger value = [node maxWidthOrValue:emptyDataColumnWidth];
        maxWidth += value;
    }];
    
    NSInteger width = rowNodesDepth + maxWidth;
    
    NSArray *rowEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootRowsNode];
    NSInteger rowNodesEndpointsCount = [rowEndpoints count];

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
        
        NSPredicate *predicate1 = [(WOTPivotNode *)obj1 predicate];
        NSPredicate *predicate2 = [(WOTPivotNode *)obj2 predicate];
        
        return [[predicate1 predicateFormat] compare:[predicate2 predicateFormat]];
    }];
    
    if (!self.pivotItemCreationBlock) {

        return;
    }

    NSArray *colNodeEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootColumnsNode];
    NSArray *rowNodeEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootRowsNode];
    [rowNodeEndpoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        WOTPivotNode *rowNode = (WOTPivotNode *)obj;
        if ([rowNode predicate]) {

            [colNodeEndpoints enumerateObjectsUsingBlock:^(id  _Nonnull cnode, NSUInteger idx, BOOL * _Nonnull stop) {

                WOTPivotNode *columnNode = (WOTPivotNode *)cnode;

                NSArray *predicates = [self predicatesFromColumnNode:columnNode rowNode:rowNode];
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
    }];
}

- (NSArray *)predicatesFromColumnNode:(WOTPivotNode *)columnNode rowNode:(WOTPivotNode *)rowNode{
    
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (columnNode.predicate)
        [predicates addObject:columnNode.predicate];
    
    if (rowNode.predicate)
        [predicates addObject:rowNode.predicate];

    NSArray *endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode: self.rootFiltersNode];
    [endpoints enumerateObjectsUsingBlock:^(WOTNode *fnode, NSUInteger idx, BOOL *stop) {
        
        WOTPivotNode *filterNode = (WOTPivotNode *)fnode;
        if (filterNode.predicate) {
            
            [predicates addObject:filterNode.predicate];
        }
    }];
 
    return predicates;
}

#pragma mark -
- (void)removeAllNodes {

    __block typeof(self)strongSelf = self;
    [self.rootDataNode removeChildren:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)strongSelf.rootDataNode setDimensionDelegate:nil];
        strongSelf.rootDataNode = nil;
    }];
    [self.rootRowsNode removeChildren:^(id<WOTNodeProtocol> _Nonnull node) {
        
        [(WOTPivotNode *)strongSelf.rootRowsNode setDimensionDelegate:nil];
        strongSelf.rootRowsNode = nil;
    }];
    [self.rootColumnsNode removeChildren:^(id<WOTNodeProtocol> _Nonnull node) {
        
        [(WOTPivotNode *)strongSelf.rootColumnsNode setDimensionDelegate:nil];
        strongSelf.rootColumnsNode = nil;
    }];
    [self.rootFiltersNode removeChildren:^(id<WOTNodeProtocol> _Nonnull node) {
        
        [(WOTPivotNode *)strongSelf.rootFiltersNode setDimensionDelegate:nil];
        strongSelf.rootFiltersNode = nil;
    }];
    
    [super removeAllNodes];
}

@end

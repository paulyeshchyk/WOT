//
//  WOTPivotTree.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotTree.h"

#import "WOTPivotNode.h"
#import "WOTPivotColNode.h"
#import "WOTPivotRowNode.h"
#import "WOTPivotFilterNode.h"
#import "WOTPivotColNode.h"
#import "WOTPivotDataNode.h"

@interface WOTPivotTree()

@property (nonatomic, strong) NSMutableArray *metadataItems;
@property (nonatomic, readwrite, strong) WOTNode *rootFiltersNode;
@property (nonatomic, readwrite, strong) WOTNode *rootColsNode;
@property (nonatomic, readwrite, strong) WOTNode *rootRowsNode;
@property (nonatomic, readwrite, strong) WOTNode *rootDataNode;
@property (nonatomic, assign)BOOL shouldDisplayEmptyColumns;

@end

@implementation WOTPivotTree

@synthesize rootFilterNode;
@synthesize rootColsNode;
@synthesize rootRowsNode;
@synthesize rootDataNode;

- (id)init {
    
    self = [super init];
    if (self){

        self.shouldDisplayEmptyColumns = NO;
        self.dimension = [[WOTDimension alloc] initWithRootNodeHolder:self];
        [self.dimension registerCalculatorClass:WOTDimensionColumnCalculator.self forNodeClass:WOTPivotColNode.self];
        [self.dimension registerCalculatorClass:WOTDimensionRowCalculator.self forNodeClass:WOTPivotRowNode.self];
        [self.dimension registerCalculatorClass:WOTDimensionFilterCalculator.self forNodeClass:WOTPivotFilterNode.self];
        [self.dimension registerCalculatorClass:WOTDimensionDataCalculator.self forNodeClass:WOTPivotDataNode.self];
    }
    return self;
}

- (void)dealloc {
    
    [self clearMetadataItems];
}

- (WOTPivotNode *)newRootNode:(NSString *)name {
    
    WOTPivotNode *result = [[WOTPivotNode alloc] initWithName:name isVisible:NO];
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

    [self.model.index reset];
    [self removeAllNodes];
    [self.metadataItems removeAllObjects];
    
}

- (void)resortMetadata {
    
    self.rootDataNode = [self newRootNode:@"root data"];

    self.rootRowsNode = [self newRootNode:@"root rows"];
    NSArray *rows = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class == %@",[WOTPivotRowNode class]]];

    [self.rootRowsNode addChildArray:rows];
    
    self.rootColsNode = [self newRootNode:@"root columns"];
    NSArray *cols = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class == %@",[WOTPivotColNode class]]];
    [self.rootColsNode addChildArray:cols];
    
    self.rootFiltersNode = [self newRootNode:@"root filter"];
    NSArray *filters = [[self metadataItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class == %@",[WOTPivotFilterNode class]]];
    [self.rootFiltersNode addChildArray:filters];
}

- (void)makePivot {
    
    [self removeAllNodes];
    
    [self resortMetadata];

    NSInteger metadataIndex = [self reindexMetaitems];

    [self makeDataForIndex: metadataIndex];
    
    [self.model.index reset];
    [self.model.index addNodesToIndex:@[self.rootFiltersNode, self.rootColsNode, self.rootRowsNode, self.rootDataNode]];
}

- (NSInteger)pivotItemsCountForRowAtIndex:(NSInteger)rowIndex {
    
    /*
     * TODO: be sure rowIndex is used
     * i.e. for case when two or more section displayed
     *
     * currently not used
     */

    return self.model.index.count;
}

- (PivotStickyType)itemStickyTypeAtIndexPath:(NSIndexPath *)indexPath {

    WOTPivotNode *node = (WOTPivotNode *)[self pivotItemAtIndexPath:indexPath];
    return node.stickyType;
}

- (CGRect)itemRectAtIndexPath:(NSIndexPath *)indexPath {

    WOTPivotNode *node = (WOTPivotNode *)[self pivotItemAtIndexPath:indexPath];
    if (node == nil) {
        return CGRectZero;
    }

    //FIXME: node.relativeRect should be optimized
    NSValue *relativeRectValue = node.relativeRect;
    if (relativeRectValue != nil) {
        return [relativeRectValue CGRectValue];
    }

    Class<WOTDimensionCalculatorProtocol> _Nullable calculator = [self.dimension calculatorClassForNodeClass: [node class]];
    if (calculator == nil) {
        return CGRectZero;
    }
    CGRect result = [calculator rectangleForNode:node dimension: self.dimension];

    node.relativeRect = [NSValue valueWithCGRect:result];
    return result;
}

- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTNode *result = [self.model.index itemWithIndexPath:indexPath];
    if (!result) {
        
        NSCAssert(NO, @"Node not found for indexPath:%@",indexPath);
    }
    
    return result;
}

#pragma mark - private
- (NSInteger) reindexMetaitems {
    __block NSInteger index = 0;

    [WOTNodeEnumerator.sharedInstance enumerateAllWithNode:self.rootFiltersNode comparator:^enum NSComparisonResult(id<WOTNodeProtocol> _Nonnull obj1, id<WOTNodeProtocol> _Nonnull obj2, NSInteger level) {
        return NSOrderedSame;
    } childCompletion:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)node setIndex:index];
        index++;
    }];

    [WOTNodeEnumerator.sharedInstance enumerateAllWithNode:self.rootColsNode comparator:^enum NSComparisonResult(id<WOTNodeProtocol> _Nonnull obj1, id<WOTNodeProtocol> _Nonnull obj2, NSInteger level) {
        return [[obj1 name] compare:[obj2 name]];
    } childCompletion:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)node setIndex:index];
        index++;
    }];

    [WOTNodeEnumerator.sharedInstance enumerateAllWithNode:self.rootRowsNode comparator:^enum NSComparisonResult(id<WOTNodeProtocol> _Nonnull obj1, id<WOTNodeProtocol> _Nonnull obj2, NSInteger level) {
        NSPredicate *predicate1 = [(WOTPivotNode *)obj1 predicate];
        NSPredicate *predicate2 = [(WOTPivotNode *)obj2 predicate];

        return [[predicate1 predicateFormat] compare:[predicate2 predicateFormat]];
    } childCompletion:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)node setIndex:index];
        index++;
    }];
    return index;
}

- (void)makeDataForIndex:(NSInteger) externalIndex {
    
    if (!self.pivotItemCreationBlock) {

        return;
    }

    __block NSInteger index = externalIndex;

    NSArray *colNodeEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootColsNode];
    NSArray *rowNodeEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootRowsNode];
    [rowNodeEndpoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        WOTPivotNode *rowNode = (WOTPivotNode *)obj;
        if ([rowNode predicate]) {

            [colNodeEndpoints enumerateObjectsUsingBlock:^(id  _Nonnull cnode, NSUInteger idx, BOOL * _Nonnull stop) {

                WOTPivotNode *columnNode = (WOTPivotNode *)cnode;

                NSArray *predicates = [self predicatesFromColumnNode:columnNode rowNode:rowNode];
                NSArray *dataNodes = self.pivotItemCreationBlock(predicates);

                [self.dimension setMaxWidth:dataNodes.count forNode:columnNode byKey:[NSString stringWithFormat:@"%d",rowNode.hash]];
                [self.dimension setMaxWidth:dataNodes.count forNode:rowNode byKey:[NSString stringWithFormat:@"%d",columnNode.hash]];

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

    [self.rootDataNode removeChildren: NULL];
    self.rootDataNode = nil;

    [self.rootRowsNode removeChildren: NULL];
    self.rootRowsNode = nil;

    [self.rootColsNode removeChildren: NULL];
    self.rootColsNode = nil;

    [self.rootFiltersNode removeChildren: NULL];
    self.rootFiltersNode = nil;

    [super removeAllNodes];
}

@end

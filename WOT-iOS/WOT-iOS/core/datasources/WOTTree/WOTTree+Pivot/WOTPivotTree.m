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
@property (nonatomic, readwrite, strong) WOTNode *rootFiltersNode;
@property (nonatomic, readwrite, strong) WOTNode *rootColsNode;
@property (nonatomic, readwrite, strong) WOTNode *rootRowsNode;
@property (nonatomic, readwrite, strong) WOTNode *rootDataNode;
@property (nonatomic, assign)BOOL shouldDisplayEmptyColumns;
@property (nonatomic, strong) id<WOTDimensionProtocol> dimension;

@end

@implementation WOTPivotTree

@synthesize rootFilterNode;
@synthesize rootColsNode;
@synthesize rootRowsNode;
@synthesize rootDataNode;

@dynamic rootNodeHeight;
@dynamic rootNodeWidth;
@dynamic contentSize;

+ (WOTPivotTree *)sharedInstance {
    static WOTPivotTree *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    if (self){

        self.shouldDisplayEmptyColumns = NO;
        self.dimension = [[WOTDimension alloc] initWithRootNodeHolder:self];
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

- (WOTNode *)pivotItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTNode *result = [self.model.index itemWithIndexPath:indexPath];
    if (!result) {
        
        NSCAssert(NO, @"Node not found for indexPath:%@",indexPath);
    }
    
    return result;
}

#pragma mark - PivotDimensionDelegate
- (NSInteger)rootNodeWidth {
    return self.dimension.rootNodeWidth;
}

- (NSInteger)rootNodeHeight {    
    return self.dimension.rootNodeHeight;
}


- (void)node:(id<WOTNodeProtocol>)node setMaxWidth:(NSInteger) maxWidth forKey:(NSString *)key {
    [self.dimension setMaxWidth:maxWidth forNode:node byKey:key];
}


- (CGSize)contentSize {
//    return self.dimension.contentSize
    NSInteger rowNodesDepth = self.dimension.rootNodeWidth;
    NSInteger colNodesDepth = self.dimension.rootNodeHeight;
    
#warning emptyDataColumnWidth should be refactored
    NSInteger emptyDataColumnWidth = self.shouldDisplayEmptyColumns ? 1 : 0;

    NSArray * columnEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootColsNode];

    __block NSInteger maxWidth = 0;
    [columnEndpoints enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {



        NSInteger value = [self.dimension maxWidth:node orValue:emptyDataColumnWidth];

//        NSInteger value = [node maxWidthOrValue:emptyDataColumnWidth];
        maxWidth += value;
    }];
    
    NSInteger width = rowNodesDepth + maxWidth;
    
    NSArray *rowEndpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:self.rootRowsNode];
    NSInteger rowNodesEndpointsCount = [rowEndpoints count];

    NSInteger height = colNodesDepth + rowNodesEndpointsCount;
    
    return CGSizeMake(width, height);
}

#pragma mark - private
- (NSInteger) reindexMetaitems {
    __block NSInteger index = 0;

    [WOTNodeEnumerator.sharedInstance enumerateAllWithNode:self.rootFiltersNode comparator:^enum NSComparisonResult(id<WOTNodeProtocol> _Nonnull obj1, id<WOTNodeProtocol> _Nonnull obj2, NSInteger level) {
        return NSOrderedSame;
    } childCompletion:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)node setIndex:index];
        [(WOTPivotNode *)node setDimensionDelegate:self.dimension];
        index++;
    }];

    [WOTNodeEnumerator.sharedInstance enumerateAllWithNode:self.rootColsNode comparator:^enum NSComparisonResult(id<WOTNodeProtocol> _Nonnull obj1, id<WOTNodeProtocol> _Nonnull obj2, NSInteger level) {
        return [[obj1 name] compare:[obj2 name]];
    } childCompletion:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)node setIndex:index];
        [(WOTPivotNode *)node setDimensionDelegate:self.dimension];
        index++;
    }];

    [WOTNodeEnumerator.sharedInstance enumerateAllWithNode:self.rootRowsNode comparator:^enum NSComparisonResult(id<WOTNodeProtocol> _Nonnull obj1, id<WOTNodeProtocol> _Nonnull obj2, NSInteger level) {
        NSPredicate *predicate1 = [(WOTPivotNode *)obj1 predicate];
        NSPredicate *predicate2 = [(WOTPivotNode *)obj2 predicate];

        return [[predicate1 predicateFormat] compare:[predicate2 predicateFormat]];
    } childCompletion:^(id<WOTNodeProtocol> _Nonnull node) {

        [(WOTPivotNode *)node setIndex:index];
        [(WOTPivotNode *)node setDimensionDelegate:self.dimension];
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

//                [columnNode setMaxWidth:dataNodes.count forKey:rowNode.hash];
//                [rowNode setMaxWidth:dataNodes.count forKey:columnNode.hash];

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
    [(WOTPivotNode *)self.rootDataNode setDimensionDelegate:nil];
    self.rootDataNode = nil;

    [self.rootRowsNode removeChildren: NULL];
    [(WOTPivotNode *)self.rootRowsNode setDimensionDelegate:nil];
    self.rootRowsNode = nil;

    [self.rootColsNode removeChildren: NULL];
    [(WOTPivotNode *)self.rootColsNode setDimensionDelegate:nil];
    self.rootColsNode = nil;

    [self.rootFiltersNode removeChildren: NULL];
    [(WOTPivotNode *)self.rootFiltersNode setDimensionDelegate:nil];
    self.rootFiltersNode = nil;

    [super removeAllNodes];
}

@end

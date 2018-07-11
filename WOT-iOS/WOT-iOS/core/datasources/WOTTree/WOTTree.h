//
//  WOTTree.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

typedef NSComparisonResult(^WOTNodeComparator)(WOTNode *left, WOTNode *right);
@class WOTDataModel;

@interface WOTTree : NSObject

@property (nonatomic, readonly) WOTDataModel *model;
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, readonly) NSInteger levels;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger endpointsCount;
@property (nonatomic, copy) WOTNodeComparator nodeComparator;
@property (nonatomic, readonly) NSSet *rootNodes;

- (NSInteger)nodesCountAtSection:(NSInteger)sectionIndex;
- (WOTNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;

- (void)addNode:(WOTNode *)node;
- (void)removeNode:(WOTNode *)node;
- (void)removeAllNodes;

- (WOTNode *)findOrCreateRootNodeByPredicate:(NSPredicate *)predicate;

@end

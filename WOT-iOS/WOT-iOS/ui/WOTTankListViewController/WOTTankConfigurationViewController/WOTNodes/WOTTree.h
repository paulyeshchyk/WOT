//
//  WOTTree.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTTree : NSObject

@property (nonatomic, readonly)NSArray *nodes;
@property (nonatomic, readonly)NSInteger levels;
@property (nonatomic, readonly)NSInteger width;
@property (nonatomic, readonly)NSInteger endpointsCount;

- (WOTNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)nodesCountAtSection:(NSInteger)sectionIndex;
- (NSInteger)endPointsCountForNode:(WOTNode *)node;

- (void)addNode:(WOTNode *)node;
- (void)removeNode:(WOTNode *)node;
- (void)reindex;
- (void)removeAllNodes;

@end

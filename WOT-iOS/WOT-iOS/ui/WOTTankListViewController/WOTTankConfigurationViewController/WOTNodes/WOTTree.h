//
//  WOTTree.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTNode.h"

@interface WOTTree : NSObject

@property (nonatomic, readonly)NSArray *nodes;
@property (nonatomic, readonly)NSInteger depth;
@property (nonatomic, readonly)NSInteger level;
@property (nonatomic, readonly)NSInteger width;
@property (nonatomic, readonly)NSInteger nodesCount;

- (void)addNode:(WOTNode *)node;
- (void)removeNode:(WOTNode *)node;

- (WOTNode *)nodeAtSiblingIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)nodesAtLevel:(NSInteger)level;

@end

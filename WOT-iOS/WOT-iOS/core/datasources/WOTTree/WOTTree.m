//
//  WOTTree.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree.h"

@interface WOTTree ()

@property (nonatomic, strong)NSMutableSet *rootNodes_;
@property (nonatomic, strong)NSMutableDictionary *levelIndex;
@property (nonatomic, readwrite, strong) WOTDataModel *model;

@end

@implementation WOTTree

- (id)init {
    if (self = [super init]) {
        self.model = [[WOTDataModel alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.model removeAll];
}

- (NSSet *)rootNodes {
    return self.model.rootNodes;
}

- (void)addNode:(WOTNode *)node {
    [self.model addWithNode:node];
}

- (void)removeAllNodes {
    [self.model removeAll];
}

- (void)removeNode:(WOTNode *)node {
    [self.model removeWithNode:node];
}

- (NSArray *)nodes {
    return [self.model allObjectsWithSortComparator:^BOOL(WOTNode * _Nonnull left, WOTNode * _Nonnull right) {
        return true;
    }];
}

- (WOTNode *)nodeAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model nodeAtIndexPath:indexPath];
}

- (NSInteger)nodesCountAtSection:(NSInteger)sectionIndex {
    return [self.model nodesCountWithSection:sectionIndex];
}

- (NSInteger)levels {
    return self.model.levels;
}

- (NSInteger)width {
    return self.model.width;
}

- (NSInteger)endpointsCount {
    return self.model.endpointsCount;
}

- (WOTNode *)findOrCreateRootNodeByPredicate:(NSPredicate *)predicate {
    
    WOTNode *rootNode = nil;

    NSSet *roots = [self.rootNodes filteredSetUsingPredicate:predicate];
    if ([roots count]  == 0) {
        
        rootNode = [[WOTNode alloc] init];
        [self addNode:rootNode];
    } else {
        
        rootNode = [roots anyObject];
    }
    
    return rootNode;
}


@end

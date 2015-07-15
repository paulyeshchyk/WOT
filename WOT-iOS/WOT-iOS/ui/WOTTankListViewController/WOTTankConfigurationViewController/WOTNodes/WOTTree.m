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

@end

@implementation WOTTree

- (void)dealloc {
    
    [self.rootNodes_ removeAllObjects];
}

- (NSSet *)rootNodes {
    
    return self.rootNodes_;
}

- (void)addNode:(WOTNode *)node {
    
    if (!self.rootNodes_) {
        
        self.rootNodes_ = [[NSMutableSet alloc] init];
    }
    
    [self.rootNodes_ addObject:node];
    [self reindex];
}

- (void)removeAllNodes {
    
    [self.rootNodes_ removeAllObjects];
    
}
- (void)removeNode:(WOTNode *)node {
    
    [self.rootNodes_ removeObject:node];
    [self reindex];
}

- (NSArray *)nodes {
    
    return [self.rootNodes_ allObjects];
}

- (void)reindex {
    
    [self.levelIndex removeAllObjects];
    self.levelIndex = [[NSMutableDictionary alloc] init];
    NSInteger level = 0;
    for (int i=0;i<self.rootNodes.count;i++) {
        
        WOTNode *node = [self.rootNodes allObjects][i];
        [self reindexChildNode:node atLevel:level];
    }
}

- (WOTNode *)nodeAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *section = self.levelIndex[@(indexPath.section)];
    return section[indexPath.row];
}

- (NSInteger)nodesCountAtSection:(NSInteger)sectionIndex {
    
    NSArray *section = self.levelIndex[@(sectionIndex)];
    return [section count];
}

- (void)reindexChildNode:(WOTNode *)node atLevel:(NSInteger)level{
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.levelIndex[@(level)]];
    [items addObject:node];
    self.levelIndex[@(level)] = [items copy];

    for (int i=0;i<node.children.count;i++) {
        
        WOTNode *childNode = node.children[i];
        [self reindexChildNode:childNode atLevel:level+1];
    }
}

- (NSInteger)levels {
    
    return [[self.levelIndex allKeys] count];
}

- (NSInteger)width {
    
    __block NSInteger result = 0;
    [[self.levelIndex allKeys] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        
        id arr = self.levelIndex[key];
        result = MAX(result,[arr count]);
    }];
    return result;
}

- (NSInteger)endpointsCount {

    __block NSInteger result = 0;
    [self.rootNodes_ enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {
    
        result += [self endPointsCountForNode:node];
    }];
    return result;
}

- (NSInteger)endPointsCountForNode:(WOTNode *)node {

    NSInteger cnt = [node.children count];

    if (cnt == 0) {
        
        return 1;
    }
    
    NSInteger result = 0;
    for (int i=0;i<cnt;i++) {
        
        WOTNode *childNode = node.children[i];
        result += [self endPointsCountForNode:childNode];
    }
    
    return result;
    
}

@end

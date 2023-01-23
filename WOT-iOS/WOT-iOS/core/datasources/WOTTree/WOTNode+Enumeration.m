//
//  WOTNode+Enumeration.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Enumeration.h"

@implementation WOTNode (Enumeration)

- (NSInteger)depth {
    
    return [WOTNode depthForChildList:self.children initialLevel:self.isVisible?1:0];
}

+ (NSInteger)depthForArray:(NSArray *)array {

    return [WOTNode depthForChildList:array initialLevel:0];
    
}

+ (NSInteger)depthForChildList:(NSArray *)childList initialLevel:(NSInteger)initialLevel {
    
    __block NSInteger result = initialLevel;
    [childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        NSInteger resultFromChild = [WOTNode depthForChildList:node.children initialLevel:(initialLevel + 1)];
        result = MAX(result, resultFromChild);
    }];

    return result;
}

- (NSArray *)endpoints {
    
    if ([self.childList count] == 0) {
        
        return @[self];
    }
    
    NSArray *array = [self.childList array];
    return [WOTNode endpointsForArray:array];
}

- (NSArray *)allItems {
    
    return [WOTNode allItemsForArray:self.children];
}

- (void)enumerateAllChildrenUsingBlock:(HierarchyEnumarationCallback)callback  comparator:(HierarchyComparator)comparator{
    
    [WOTNode enumerateItemsHierarchy:self.children callback:callback comparator:comparator];
}

- (void)enumerateEndpointsUsingBlock:(HierarchyEnumarationCallback)callback {
    
    [[WOTNode endpointsForArray:self.children] enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        if (callback) {
            
            callback(node);
        }
    }];
}

+ (void)enumerateItemsHierarchy:(NSArray *)items callback:(HierarchyEnumarationCallback)callback comparator:(HierarchyComparator)comparator{
    
    NSArray *sortedItems = [items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

        if (comparator) {
            
            return comparator(obj1, obj2,@(-1));
        }
        return NSOrderedSame;
    }];
    
    [sortedItems enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        if (callback){
            
            callback(node);
        }
        
        [WOTNode enumerateItemsHierarchy:node.children callback:callback comparator:comparator];
    }];
}

+ (NSArray *)allItemsForArray:(NSArray *)childArray {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:childArray];
    [childArray enumerateObjectsUsingBlock:^(WOTNode *child, NSUInteger idx, BOOL *stop) {

        NSArray *childItems = [WOTNode allItemsForArray:child.children];
        [result addObjectsFromArray:childItems];
        
    }];
    return result;
}

+ (NSArray *)endpointsForArray:(NSArray *)childArray {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [childArray enumerateObjectsUsingBlock:^(WOTNode *child, NSUInteger idx, BOOL *stop) {
        
        [result addObjectsFromArray:child.endpoints];
        
    }];
    return result;
}

+ (WOTNode *)endpointForArray:(NSArray *)childArray atIndexPath:(NSIndexPath *)indexPath{
    
    return [WOTNode endpointForArray:childArray atIndexPath:indexPath initialLevel:0];
}

+ (WOTNode *)endpointForArray:(NSArray *)childArray atIndexPath:(NSIndexPath *)indexPath initialLevel:(NSInteger)initialLevel{
    
    __block WOTNode *result = nil;
    if (initialLevel == indexPath.section) {
        
        if (indexPath.row < [childArray count]) {
            
            result = childArray[indexPath.row];
        }
    } else {
        
        [childArray enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
            
            result = [self endpointForArray:[node.childList array] atIndexPath:indexPath initialLevel:(indexPath.section + 1)];
            if (result) {
                
                *stop = YES;
            }
        }];
    }
    
    return result;
}

- (NSInteger)parentsCount {
    
    return [self parentsCountForNode:self];
}

- (NSInteger)parentsCountForNode:(WOTNode *)node {
    
    if (!node.parent) {
        
        return 0;
    }
    
    NSInteger result = 1;
    result += [self parentsCountForNode:node.parent];
    return result;
}

- (NSInteger)visibleParentsCount {
    
    return [self visibleParentsCountForNode:self];
}

- (NSInteger)visibleParentsCountForNode:(WOTNode *)node {
    
    WOTNode *parent = node.parent;
    if (!parent) {
        
        return 0;
    }
    
    if (!parent.isVisible) {
        
        return 0;
    }
    
    NSInteger result = 1;
    result += [self visibleParentsCountForNode:parent];
    return result;
}

- (NSInteger)childrenCountForSiblingNode {
    
    return [self childrenCountForSiblingNode:self];
}

- (NSInteger)childrenCountForSiblingNode:(WOTNode *)node {
    
    __block NSInteger result = 0;
    WOTNode *parent = node.parent;
    if (parent) {
        
        NSInteger indexOfNode = [parent.children indexOfObject:node];
        for (int i=0;i<indexOfNode;i++) {
            
            WOTNode *child = parent.children[i];
            NSArray *endpoints = child.endpoints;
            result += [endpoints count];
        }
        
        result += [self childrenCountForSiblingNode:parent];
    }
    
    return result;
}


@end

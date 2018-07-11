//
//  WOTNode+Enumeration.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Enumeration.h"

@implementation WOTNode (Enumeration)


- (NSArray *)endpoints {
    return [WOTNodeEnumerator.sharedInstance endpointsWithNode: self];
}

- (NSArray *)allItems {    
    return [WOTNodeEnumerator.sharedInstance allItemsFromArray:self.children];
}

- (void)enumerateAllChildrenUsingBlock:(HierarchyEnumarationCallback)callback  comparator:(HierarchyComparator)comparator{
    
    [WOTNode enumerateItemsHierarchy:self.children callback:callback comparator:comparator];
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

+ (WOTNode *)endpointForArray:(NSArray *)childArray atIndexPath:(NSIndexPath *)indexPath initialLevel:(NSInteger)initialLevel{
    
    __block WOTNode *result = nil;
    if (initialLevel == indexPath.section) {
        
        if (indexPath.row < [childArray count]) {
            
            result = childArray[indexPath.row];
        }
    } else {
        
        [childArray enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
            
            result = [self endpointForArray:[node.childList allObjects] atIndexPath:indexPath initialLevel:(indexPath.section + 1)];
            if (result) {
                
                *stop = YES;
            }
        }];
    }
    
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
            NSArray *endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode: child];
            result += [endpoints count];
        }
        
        result += [self childrenCountForSiblingNode:parent];
    }
    
    return result;
}


@end

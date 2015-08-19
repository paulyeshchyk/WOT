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
    
    return [self depthForChildList:self.childList initialLevel:1];
}

- (NSInteger)depthForChildList:(NSMutableOrderedSet *)childList initialLevel:(NSInteger)initialLevel {
    
    __block NSInteger result = initialLevel;
    [childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        NSInteger resultFromChild = [self depthForChildList:node.childList initialLevel:(initialLevel + 1)];
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

@end

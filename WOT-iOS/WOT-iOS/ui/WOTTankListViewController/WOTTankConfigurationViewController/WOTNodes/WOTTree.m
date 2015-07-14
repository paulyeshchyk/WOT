//
//  WOTTree.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree.h"

@interface WOTTree ()

@property (nonatomic, strong)NSMutableSet *rootNodes;

@end

@implementation WOTTree

- (void)addNode:(WOTNode *)node {
    
    if (!self.rootNodes) {
        
        self.rootNodes = [[NSMutableSet alloc] init];
    }
    
    [self.rootNodes addObject:node];
}

- (void)removeNode:(WOTNode *)node {
    
    [self.rootNodes removeObject:node];
}

- (NSArray *)nodes {
    
    return [self.rootNodes allObjects];
}

- (NSInteger)depth {
    
    __block NSInteger result = 0;
    
    [self.rootNodes enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {
        
        result = MAX(result,node.depth);
        
    }];
    
    NSInteger hasChildrenDepth = ([self.rootNodes count] == 0)?0:1;
    return result + hasChildrenDepth;
}

- (NSInteger)width {
    
    __block NSInteger result = 0;
    
    [self.rootNodes enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {
        
        result = MAX(result, node.width);
        
    }];
    
    
    return result;
}

- (NSInteger)nodesCount {
    
    __block NSInteger result = [self.rootNodes count];
    
    [self.rootNodes enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {
        
        result += [node.allChildren count];
        
    }];
    return result;
}

- (WOTNode *)nodeAtSiblingIndexPath:(NSIndexPath *)indexPath {

    __block WOTNode *result = nil;
    [self.rootNodes enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {

        if ([node.siblingIndexPath isEqual:indexPath]) {
            
            *stop = YES;
            result = node;
        } else {
            
            result = [node nodeAtSiblingIndexPath:indexPath];
            if (result) {
                
                *stop = YES;
            }
        }
    }];
    if (result == nil) {
        
        debugLog(@"failed for %@",indexPath);
    }
    return result;
}

- (NSArray *)nodesAtLevel:(NSInteger)level {

    __block NSMutableArray *result = [[NSMutableArray alloc] init];

    [self.rootNodes enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {
       
        if (node.level == level) {
            
            [result addObject:node];
        }// else {

            [result addObjectsFromArray:[node nodesAtLevel:level]];
//        }
     
    }];
    
    return [result copy];
}
@end

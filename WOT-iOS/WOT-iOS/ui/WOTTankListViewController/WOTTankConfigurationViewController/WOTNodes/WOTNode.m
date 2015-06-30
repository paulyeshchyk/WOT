//
//  WOTNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode ()

@property (nonatomic, strong)NSMutableOrderedSet *childList;
@property (nonatomic, weak)WOTNode *parent;

@end

@implementation WOTNode

- (void)dealloc {
    
}

- (id)initWithName:(NSString *)name parent:(WOTNode *)parent{
    
    self = [super init];
    if (self){
        
        self.name = name;
        self.parent = parent;
    }
    return self;
}

- (NSArray *)children {
    
    return [self.childList array];
}

- (NSIndexPath *)siblingIndexPath {
    
    return [NSIndexPath indexPathForRow:[self.parent siblingIndexOfChild:self] inSection:self.level];
}

- (NSInteger)indexOfChild:(WOTNode *)node {

    return [self.childList indexOfObject:node];
}

- (NSInteger)siblingIndexOfChild:(WOTNode *)node {
    
    return [self indexOfChild:node];
}

- (NSInteger)level {
    
    NSInteger result = 0;
    if (self.parent) {
        
        result =  (self.parent.level + 1);
    } else {
        
    }
    return result;
}

- (void)addChild:(WOTNode *)child {
    
    if (!self.childList) {
        
        self.childList = [[NSMutableOrderedSet alloc] init];
    }
    [self.childList addObject:child];
}

- (void)removeChild:(WOTNode *)child {
    
    [self.childList removeObject:child];
}

- (void)addChildren:(NSSet *)childrenSet {
    
    if (!self.childList) {
        
        self.childList = [[NSMutableOrderedSet alloc] init];
    }
    
    [self.childList unionSet:childrenSet];
}

- (NSArray *)allChildren {
    
    __block NSMutableArray *result = [[NSMutableArray alloc] init];

    [self.childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
    
        [result addObject:node];
        [result addObjectsFromArray:node.allChildren];
    }];
    
    return result;
}

- (NSInteger)width {
    
    __block NSInteger result = 0;
    
    [self.childList enumerateObjectsUsingBlock:^(WOTNode *childNode,  NSUInteger idx, BOOL *stop) {
        
        NSInteger childNodeWidth = childNode.width;
        if (childNodeWidth == 0) {
            
            result += 1;
        } else if (childNodeWidth == 1) {
            
            result += 1;
        } else {

            //idx???
            result +=(0 + childNodeWidth);
        }
    }];
    
    return result;
}

- (NSArray *)nodesAtLevel:(NSInteger)level {

    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [self.childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        if (node.level == level) {
            
            [result addObject:node];
        }// else {
            
            [result addObjectsFromArray:[node nodesAtLevel:level]];
//        }
        
    }];
    
    return [result copy];
}

- (WOTNode *)nodeAtSiblingIndexPath:(NSIndexPath *)indexPath {

    __block WOTNode *result = nil;
    
    [self.childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
       
        if ([node.siblingIndexPath isEqual:indexPath]) {
            
            *stop = YES;
            result = node;
        } else {
            
            result = [node nodeAtSiblingIndexPath:indexPath];
            if (result){
                
                *stop = YES;
            }
        }
    }];
    
    return result;
    
}

- (NSInteger)depth {
    
    return [self depthForLevel:0];
}

#pragma mark - private
- (NSInteger)depthForLevel:(NSInteger)depthForLevel {
    
    __block NSInteger result = depthForLevel;
    
    [self.childList enumerateObjectsUsingBlock:^(WOTNode *obj, NSUInteger idx, BOOL *stop) {
        
        NSInteger nextLevel = (depthForLevel +1);
        NSInteger childDepth = [obj depthForLevel:nextLevel];
        result = MAX(result,childDepth);
    }];
    return result;
}

@end

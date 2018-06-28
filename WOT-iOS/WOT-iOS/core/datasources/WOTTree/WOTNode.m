//
//  WOTNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode ()

@property (nonatomic, readwrite, strong)NSMutableOrderedSet *childList;
@property (nonatomic, readwrite, strong)NSURL *imageURL;

@end

@implementation WOTNode

- (void)dealloc {
    
    [self removeAllNodesWithCompletionBlock:NULL];
}

- (id)init {
    
    self = [super init];
    if (self){
    
        self.isVisible = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    WOTNode *result = [[[self class] allocWithZone: zone] init];
    result.isVisible = self.isVisible;
    result.imageURL = self.imageURL;
    result.name = self.name;
    return result;
}

- (id)initWithName:(NSString *)name {
    
    self = [self init];
    if (self){
        
        self.name = name;
    }
    return self;
}

- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL{
    
    self = [self initWithName:name];
    if (self){
        
        self.imageURL = imageURL;
    }
    return self;
}

- (NSUInteger)hash {
    
    return [self.name hash];
}


- (NSArray *)children {
    
    return [self.childList array];
}

- (NSString *)fullName {
    
    if (self.parent == nil) {
        
        return self.name;
    } else {
        
        NSString *parentFullName = self.parent.fullName;
        return [NSString stringWithFormat:@"%@.%@",parentFullName,self.name];
    }
    
}

- (void)addChild:(WOTNode * _Nonnull)child {
    
    if (!self.childList) {
        
        self.childList = [[NSMutableOrderedSet alloc] init];
    }
    
    child.parent = self;
    [self.childList addObject:child];
}

- (void)removeAllNodesWithCompletionBlock:(WOTNodeRemoveCompletionBlock)completionBlock {
    
    [self.childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {

        if (completionBlock) {
            
            completionBlock(node);
        }
        node.parent = nil;
        [node removeAllNodesWithCompletionBlock:completionBlock];
    }];
    [self.childList removeAllObjects];
}

- (void)addChildArray:(NSArray *)childArray {
    
    NSSet *set = [NSSet setWithArray:childArray];
    [self addChildren:set];
}

- (void)removeChild:(WOTNode *)child completionBlock:(WOTNodeRemoveCompletionBlock)completionBlock{

    if (completionBlock) {
        
        completionBlock(child);
    }
    child.parent = nil;
    [self.childList removeObject:child];
}

- (void)addChildren:(NSSet *)childrenSet {
    
    if (!self.childList) {
        
        self.childList = [[NSMutableOrderedSet alloc] init];
    }
    
    [childrenSet enumerateObjectsUsingBlock:^(WOTNode *node, BOOL *stop) {
        
        node.parent = self;
    }];
    
    
    [self.childList unionSet:childrenSet];
}

@end

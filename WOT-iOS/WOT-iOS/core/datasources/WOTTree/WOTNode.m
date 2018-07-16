//
//  WOTNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode ()
@property (nonatomic, readwrite, strong)NSMutableOrderedSet<WOTNodeProtocol> *childSet;
@end

@implementation WOTNode

@synthesize imageURL;
@synthesize isVisible;
@synthesize name;
@synthesize parent;
@synthesize childList;
@synthesize index;
@synthesize hashString;
@synthesize stepParentRow;
@synthesize stepParentColumn;
@synthesize indexInsideStepParentColumn;
@synthesize relativeRect;

- (NSString *)hashString {

    return [NSString stringWithFormat:@"%d",self.hash];
}

- (void)dealloc {

    [self removeChildren: NULL];
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
    return [self.childSet array];
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
    
    if (!self.childSet) {
        
        self.childSet = [[NSMutableOrderedSet<WOTNodeProtocol> alloc] init];
    }
    
    child.parent = self;
    [self.childSet addObject:child];
}

- (void)removeChild:(id<WOTNodeProtocol>)child completion:(void (^)(id<WOTNodeProtocol> _Nonnull))completion {

    [self.childSet enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {

        if (completion) {

            completion(node);
        }
        node.parent = nil;
        [node removeChildren: NULL];

    }];
    [self.childSet removeAllObjects];
}

- (void)removeChildren:(void (^)(id<WOTNodeProtocol> _Nonnull))completion {
    [self.childSet enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {

        if (completion) {

            completion(node);
        }
        node.parent = nil;
        [node removeChildren: NULL];
    }];
    [self.childSet removeAllObjects];
}

- (void)removeAllNodesWithCompletionBlock:(WOTNodeRemoveCompletionBlock)completionBlock {
    
    [self.childSet enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {

        if (completionBlock) {
            
            completionBlock(node);
        }
        node.parent = nil;
        [node removeAllNodesWithCompletionBlock:completionBlock];
    }];
    [self.childSet removeAllObjects];
}

- (void) addChildArray:(NSArray<id<WOTNodeProtocol>> *)childArray {
    
    NSSet<WOTNodeProtocol> *set = [NSSet<WOTNodeProtocol> setWithArray:childArray];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull child, BOOL * _Nonnull stop) {
        id<WOTNodeProtocol> node = child;
        node.parent = self;

    }];

    if (!self.childSet) {
        self.childSet =  [[NSMutableOrderedSet<WOTNodeProtocol> alloc] init];
    }

    [self.childSet unionSet: set];
}

- (void)removeChild:(id<WOTNodeProtocol>)child completionBlock:(WOTNodeRemoveCompletionBlock)completionBlock{

    if (completionBlock) {
        
        completionBlock(child);
    }
    child.parent = nil;
    [self.childSet removeObject:child];
}

- (NSOrderedSet *)childList {
    return self.childSet;
}

@end

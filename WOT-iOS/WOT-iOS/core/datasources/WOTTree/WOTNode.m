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
    
    [self removeAllNodes];
}

- (id)init {
    
    self = [super init];
    if (self){
    
        self.isVisible = YES;
    }
    return self;
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

- (void)addChild:(WOTNode *)child {
    
    if (!self.childList) {
        
        self.childList = [[NSMutableOrderedSet alloc] init];
    }
    
    child.parent = self;
    [self.childList addObject:child];
}

- (void)removeAllNodes {
    
    [self.childList enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
       
        node.parent = nil;
        [node removeAllNodes];
    }];
    [self.childList removeAllObjects];
}

- (void)addChildArray:(NSArray *)childArray {
    
    NSSet *set = [NSSet setWithArray:childArray];
    [self addChildren:set];
}

- (void)removeChild:(WOTNode *)child {

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


//#pragma mark - NSCopying
//- (id)copyWithZone:(NSZone *)zone {
//    
//    
//    WOTNode *copy = [[[self class] allocWithZone: zone] init];
//    copy.name = self.name;
//    copy.subtitle = self.subtitle;
//    copy.imageurlPath = self.imageurlPath;
//    copy.redirectedurlPath = self.redirectedurlPath;
//    copy.streamType = self.streamType;
//    copy.duration = self.duration;
//    copy.position = self.position;
//    
//}


@end

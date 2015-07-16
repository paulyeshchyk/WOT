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
@property (nonatomic, copy)NSURL *imageURL;
@end

@implementation WOTNode

- (void)dealloc {
    
    [self.childList removeAllObjects];
}

- (id)initWithName:(NSString *)name {
    
    self = [super init];
    if (self){
        
        self.name = name;
    }
    return self;
}

- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL{
    
    self = [super init];
    if (self){
        
        self.name = name;
        self.imageURL = imageURL;
    }
    return self;
}

- (UIImage *)image {
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
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

- (void)removeChild:(WOTNode *)child {

    child.parent = nil;
    [self.childList removeObject:child];
}

- (void)addChildren:(NSSet *)childrenSet {
    
    if (!self.childList) {
        
        self.childList = [[NSMutableOrderedSet alloc] init];
    }
    
    [self.childList unionSet:childrenSet];
}

@end

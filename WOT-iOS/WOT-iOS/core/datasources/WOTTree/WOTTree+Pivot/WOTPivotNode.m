//
//  WOTPivotNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotNode.h"
#import "WOTNode+Enumeration.h"

@interface WOTPivotNode ()

@property (nonatomic, strong) NSValue *relativeRectValue;

@end

@implementation WOTPivotNode

- (id)copyWithZone:(NSZone *)zone {
    
    WOTPivotNode *result = [super copyWithZone:zone];
    
    result.dataColor = self.dataColor;
    result.predicate = self.predicate;
    return result;
}

- (id)copyWithPredicate:(NSPredicate *)predicate {

    WOTPivotNode *result = [self copy];
    result.predicate = predicate;
    return result;
}

- (id)initWithName:(NSString *)name predicate:(NSPredicate *)predicate {
    
    self = [self initWithName:name];
    if (self) {
        
        [self setPredicate:predicate];
    }
    return self;
}

- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL predicate:(NSPredicate *)predicate {
    
    self = [self initWithName:name imageURL:imageURL];
    if (self){
        
        [self setPredicate:predicate];
    }
    return self;
}

- (id)initWithName:(NSString *)name dimensionDelegate:(id<WOTPivotDimensionProtocol>)dimensionDelegate isVisible:(BOOL)isVisible {
    
    self = [self initWithName:name];
    if (self){
        
        self.isVisible = isVisible;
        self.dimensionDelegate = dimensionDelegate;
    }
    return self;
}

- (void)dealloc {
    
    self.dimensionDelegate = nil;
}

#pragma mark - getters / setters

- (PivotStickyType)stickyType {
    
    return PivotStickyTypeFloat;
}

- (CGRect)relativeRect {
    
    NSValue *relativeRectValue = self.relativeRectValue;
    if (relativeRectValue) {
        
        return [relativeRectValue CGRectValue];
    }
    
    NSInteger x = [self x];
    NSInteger y = [self y];
    NSInteger width = [self width];
    NSInteger height = [self height];
    CGRect result = CGRectMake(x,y,width, height);
    
    self.relativeRectValue =[NSValue valueWithCGRect:result];
    
    return result;
}

- (NSInteger)x {
    
    return 0;
}

- (NSInteger)y{
    
    return 0;
}

- (NSInteger)width {
    
    return 0;
}

- (NSInteger)height {
    
   return 0;
}

#pragma mark - 
- (NSInteger)childrenMaxWidthForSiblingNode:(WOTNode *)node orValue:(NSInteger)value{
    
    __block NSInteger result = 0;
    WOTNode *parent = node.parent;
    if (parent) {
        
        NSInteger indexOfNode = [parent.children indexOfObject:node];
        for (int i=0;i<indexOfNode;i++) {
            
            WOTNode *child = parent.children[i];
            NSArray *endpoints = child.endpoints;
            [endpoints enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
                
                result += [node maxWidthOrValue:value];
            }];
        }
        
        result += [self childrenMaxWidthForSiblingNode:parent orValue:value];
    }
    
    return result;
}


- (NSInteger)childrenWidthForSiblingNode:(WOTNode *)node orValue:(NSInteger)value{
    
    __block NSInteger result = 0;
    WOTNode *parent = node.parent;
    if (parent) {
        
        NSInteger indexOfNode = [parent.children indexOfObject:node];
        for (int i=0;i<indexOfNode;i++) {
            
            WOTNode *child = parent.children[i];
            NSArray *endpoints = child.endpoints;
            [endpoints enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
                
                result += value;
            }];
        }
        
        result += [self childrenWidthForSiblingNode:parent orValue:value];
    }
    
    return result;
}

- (NSInteger)maxWidthForKey:(id)key {
    
    return [[self sizesMap][key] integerValue];
}

- (void)setMaxWidth:(NSInteger)width forKey:(id)key {
    
    if (width == 0) {
        
        return;
    }
    
    NSDictionary *prevMap = [self sizesMap];
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    [map addEntriesFromDictionary:prevMap];
    
    NSNumber *value = map[key];
    map[key] = @(MAX(width,[value integerValue]));
    [self setSizesMap:[map copy]];
}

- (NSInteger)maxWidthOrValue:(NSInteger)value {
    
    __block NSInteger result = value;
    NSDictionary *map = [self sizesMap];
    [[map allKeys] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        
        result = MAX([map[key] integerValue],result);
    }];
    
    return result;
}

@end

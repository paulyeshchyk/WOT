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

- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate {
    
    self = [self initWithName:name imageURL:imageURL];
    if (self){
        
        [self setPivotMetadataType:metadataType];
        [self setPredicate:predicate];
    }
    return self;
}

- (id)initWithName:(NSString *)name pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate {
    
    self = [self initWithName:name];
    if (self) {
        
        [self setPivotMetadataType:metadataType];
        [self setPredicate:predicate];
    }
    return self;
}

- (PivotStickyType)stickyType {
    
    PivotMetadataType metadataType = [self pivotMetadataType];
    PivotStickyType result = PivotStickyTypeFloat;
    switch (metadataType) {
        case PivotMetadataTypeFilter:
            result = PivotStickyTypeHorizontal | PivotStickyTypeVertical;
            break;
        case PivotMetadataTypeRow:
            result = PivotStickyTypeHorizontal;
            break;
        case PivotMetadataTypeColumn:
            result = PivotStickyTypeVertical;
            break;
        default:
            break;
    }
    return result;
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
    
    NSInteger result = 0;
    switch (self.pivotMetadataType) {
            
        case PivotMetadataTypeRow:{
            
            result = [self visibleParentsCount];
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = 0;
            break;
        }
        case PivotMetadataTypeColumn:{
            
            result += [self childrenMaxWidthForSiblingNode:self orValue:0];
            result += self.dimensionDelegate.rootNodeWidth;
            break;
        }
        case PivotMetadataTypeData:{
            
            result += [[self stepParentColumn] relativeRect].origin.x;
            result += [self indexInsideStepParentColumn];
            
            break;
        }
            
        default:{
            
            break;
        }
    }
    return result;
}

- (NSInteger)y{
    
    NSInteger result = 0;
    switch (self.pivotMetadataType) {
            
        case PivotMetadataTypeFilter:{
            
            result = 0;
            break;
        }
        case PivotMetadataTypeColumn:{
            
            result = self.visibleParentsCount;
            break;
        }
        case PivotMetadataTypeRow:{
            
            result += [self childrenWidthForSiblingNode:self orValue:1];
            result += self.dimensionDelegate.rootNodeWidth;
            break;
        }
        case PivotMetadataTypeData:{
            
            result = [[self stepParentRow] relativeRect].origin.y;
            break;
        }
        default:{
            
            break;
        }
    }
    return result;
}

- (NSInteger)width {
    
    __block NSInteger result = 0;
    switch (self.pivotMetadataType) {
        case PivotMetadataTypeRow:{
            
            result = 1;
            break;
        }
        case PivotMetadataTypeColumn: {
            
            NSArray *endPoints = self.endpoints;
            if ([endPoints count] == 0) {
                
                result = 1;
            } else {
                
                [endPoints enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
                    
                    result += [node maxWidthOrValue:0];
                }];
            }
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = self.dimensionDelegate.rootNodeWidth;
            break;
        }
        case PivotMetadataTypeData: {
            result = 1;
            break;
        }
            
        default: {
            break;
        }
    }
    
    return result;
}

- (NSInteger)height {
    
    __block NSInteger result = 0;
    switch (self.pivotMetadataType) {
            
        case PivotMetadataTypeRow:{
            
            result = self.endpoints.count;
            break;
        }
        case PivotMetadataTypeColumn:{
            
            result = 1;
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = self.dimensionDelegate.rootNodeHeight;
            break;
        }
        case PivotMetadataTypeData:{
            
            result = 1;
            break;
        }
        default:{
            
            break;
        }
    }
    return result;
}

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

//
//  WOTNode+Pivot.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Pivot.h"
#import "WOTNode+Enumeration.h"
#import <objc/runtime.h>

@implementation WOTNode (Pivot)

@dynamic predicate;
@dynamic pivotMetadataType;
@dynamic data;
@dynamic index;
@dynamic stepParentColumn;
@dynamic stepParentRow;
@dynamic indexInsideStepParentColumn;
@dynamic stickyType;

- (id)initWithName:(NSString *)name tree:(WOTTree *)tree isVisible:(BOOL)isVisible{
    
    self = [self initWithName:name];
    if (self){
        
        self.isVisible = isVisible;
        self.tree = tree;
    }
    return self;
}

- (void)dealloc {
    
    self.tree = nil;
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
    
    NSValue *relativeRectValue = [self relativeRectValue];
    if (relativeRectValue) {
        
        return [relativeRectValue CGRectValue];
    }

    NSInteger x = [self x];
    NSInteger y = [self y];
    NSInteger width = [self width];
    NSInteger height = [self height];
    CGRect result = CGRectMake(x,y,width, height);

    [self setRelativeRectValue:[NSValue valueWithCGRect:result]];
    
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
            result += self.tree.rootRowsNode.depth;
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
            result += self.tree.rootRowsNode.depth;
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
            
                [endPoints enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
                    
                    result += [node maxWidthOrValue:0];
                }];
            }
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = self.tree.rootRowsNode.depth;
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
            
            result = self.tree.rootColumnsNode.depth;
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
            [endpoints enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
                
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

#pragma mark - getters / setters
static const void *SizesMapRef = &SizesMapRef;
- (NSDictionary *)sizesMap {
    
    return objc_getAssociatedObject(self, SizesMapRef);
}

- (void)setSizesMap:(NSDictionary *)sizesMap {
    
    objc_setAssociatedObject(self, SizesMapRef, sizesMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *TreeRef = &TreeRef;
- (WOTTree *)tree {

    if (self.parent) {
        
        return self.parent.tree;
    } else {
        
        return objc_getAssociatedObject(self, TreeRef);
    }
}

- (void)setTree:(WOTTree *)tree {
    
    objc_setAssociatedObject(self, TreeRef, tree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *IndexRef = &IndexRef;
- (NSInteger)index {
    
    return [objc_getAssociatedObject(self, IndexRef) integerValue];
}

- (void)setIndex:(NSInteger)index {
    
    objc_setAssociatedObject(self, IndexRef, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *PivotPredicate = &PivotPredicate;
- (void)setPredicate:(NSPredicate *)predicate {
    
    objc_setAssociatedObject(self, PivotPredicate, predicate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSPredicate *)predicate {
    
    return objc_getAssociatedObject(self, PivotPredicate);
}

static const void *PivotMetadataTypeRef = &PivotMetadataTypeRef;
- (void)setPivotMetadataType:(PivotMetadataType)pivotMetadataType {
    
    objc_setAssociatedObject(self, PivotMetadataTypeRef, @(pivotMetadataType), OBJC_ASSOCIATION_COPY);
}

- (PivotMetadataType)pivotMetadataType {
    
    return [objc_getAssociatedObject(self, PivotMetadataTypeRef) integerValue];
}

static const void *PivotDataRef = &PivotDataRef;
- (void)setData:(id)data {
    
    objc_setAssociatedObject(self, PivotDataRef, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)data {
    
    return objc_getAssociatedObject(self, PivotDataRef);
}

static const void *IndexInsideStepParentColumnRef = &IndexInsideStepParentColumnRef;
- (NSInteger )indexInsideStepParentColumn {
    
    return [objc_getAssociatedObject(self, IndexInsideStepParentColumnRef) integerValue];
}

- (void)setIndexInsideStepParentColumn:(NSInteger)indexInsideStepParentColumn {
    
    objc_setAssociatedObject(self, IndexInsideStepParentColumnRef, @(indexInsideStepParentColumn), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *StepParentColumnRef = &StepParentColumnRef;
- (WOTNode *)stepParentColumn {
    
    return objc_getAssociatedObject(self, StepParentColumnRef);
}

- (void)setStepParentColumn:(WOTNode *)stepParentColumn {
    
    objc_setAssociatedObject(self, StepParentColumnRef, stepParentColumn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *RelativeRectValueRef = &RelativeRectValueRef;
- (NSValue *)relativeRectValue {
    
    return objc_getAssociatedObject(self, RelativeRectValueRef);
}

- (void)setRelativeRectValue:(NSValue *)relativeRectValue {
    
    
    objc_setAssociatedObject(self, RelativeRectValueRef, relativeRectValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static const void *StepParentRowRef = &StepParentRowRef;
- (WOTNode *)stepParentRow {
    
    return objc_getAssociatedObject(self, StepParentRowRef);
}

- (void)setStepParentRow:(WOTNode *)stepParentRow {
    
    
    objc_setAssociatedObject(self, StepParentRowRef, stepParentRow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




@end

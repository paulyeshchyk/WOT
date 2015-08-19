//
//  WOTNode+Pivot.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Pivot.h"
#import <objc/runtime.h>

@implementation WOTNode (Pivot)

- (id)initWithName:(NSString *)name pivotMetadataType:(PivotMetadataType)metadataType predicate:(NSPredicate *)predicate {
    
    self = [self initWithName:name];
    if (self) {
        
        [self setPivotMetadataType:metadataType];
        [self setPredicate:predicate];
    }
    return self;
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



- (void)addStepParentsFromArray:(NSArray *)stepParents {
    
}

@end

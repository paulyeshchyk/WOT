//
//  WOTPivotNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotNode.h"

@implementation WOTPivotNode


#pragma mark -
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

- (id)initWithName:(NSString *)name isVisible:(BOOL)isVisible {
    
    self = [self initWithName:name];
    if (self){
        
        self.isVisible = isVisible;
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - getters / setters

- (PivotStickyType)stickyType {
    
    return PivotStickyTypeFloat;
}

@end

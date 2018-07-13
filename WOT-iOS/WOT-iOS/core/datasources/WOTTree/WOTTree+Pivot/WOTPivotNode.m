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

- (id)initWithName:(NSString *)name dimensionDelegate:(id<WOTDimensionProtocol>)dimensionDelegate isVisible:(BOOL)isVisible {
    
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
    
    self.relativeRectValue = [NSValue valueWithCGRect:result];
    
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


@end

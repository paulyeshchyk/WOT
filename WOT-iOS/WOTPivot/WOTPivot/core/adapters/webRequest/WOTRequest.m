//
//  WOTRequest.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRequest.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTPivot/WOTPivot-Swift.h>

@interface WOTRequest ()

@property (nonatomic, strong)NSMutableArray *groups;

@end

@implementation WOTRequest

- (id)init {
    
    self = [super init];
    if (self){
        
        self.listeners = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.listeners removeAllObjects];
}

- (void)addListener:(id<WOTRequestListener>)listener {
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<WOTRequestListener>)listener {
    [self.listeners removeObject:listener];
}


- (void)start:(WOTRequestArguments * _Nonnull)args {
    NSCAssert(NO, @"should be overriden");
}

- (void)cancel {
    
    NSCAssert(NO, @"should be overriden");
}

- (void)cancelAndRemoveFromQueue {
    NSCAssert(NO, @"should be overriden");
}

- (BOOL)isEqual:(id)object {

    BOOL result = [NSStringFromClass([object class]) isEqualToString:NSStringFromClass([self class])];
    NSUInteger selfHash = [self hash];
    NSUInteger objectHash = [(WOTRequest *)object hash];
    result &= (selfHash == objectHash);
    
    return result;
}

- (NSUInteger)hash {
    
    return [self.args hash];
}

- (NSArray *)availableInGroups {
 
    return self.groups;
}

- (void)addGroup:(NSString *)group {
    
    if (!self.groups) {
        
        self.groups = [[NSMutableArray alloc] init];
    }
    
    [self.groups addObject:group];
    
}

- (void)removeGroup:(NSString *)group {
    
    if (self.groups) {
        
        [self.groups removeObject:group];
    }
    
}

@end

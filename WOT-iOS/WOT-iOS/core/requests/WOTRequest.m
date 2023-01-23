//
//  WOTRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequest.h"

@interface WOTRequest ()

@property (nonatomic, readwrite)NSDictionary *args;
@property (nonatomic, strong)NSMutableArray *groups;

@end

@implementation WOTRequest

- (void)temp_executeWithArgs:(NSDictionary *)args{
    
    self.args = [args copy];
}

- (void)cancel {
    
    NSCAssert(NO, @"should be overriden");
}

- (BOOL)isEqual:(id)object {

    BOOL result = [NSStringFromClass([object class]) isEqualToString:NSStringFromClass([self class])];
    
    result &= ([object hash] == [self hash]);
    
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

//
//  WOTTanksIDList.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTanksIDList.h"

@interface WOTTanksIDList ()

@property (nonatomic, strong)NSMutableArray *innerAllObjects;

@end

@implementation WOTTanksIDList

- (id)initWithId:(NSNumber *)tankId {

    self = [super init];
    if (self){
        
        [self addObject:tankId];
    }
    return self;
}

- (void)addObject:(id)object {
    
    if (!self.innerAllObjects) {
        
        self.innerAllObjects = [[NSMutableArray alloc] init];
    }
    [self.innerAllObjects addObject:object];
}

- (void)addArrayOfObjects:(NSArray *)objects {
    
    if (!self.innerAllObjects) {
        
        self.innerAllObjects = [[NSMutableArray alloc] init];
    }
    [self.innerAllObjects addObjectsFromArray:objects];
}

- (NSArray *)allObjects {
    
    return [self.innerAllObjects copy];
}

- (NSString *)label {
    
    return [self.innerAllObjects componentsJoinedByString:@"-"];
}

@end

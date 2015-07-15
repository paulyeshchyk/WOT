//
//  WOTNode+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Tanks.h"
#import "ModulesTree.h"

@implementation WOTNode (Tanks)

- (id)initWithModule:(id)module {
    
    self = [super init];
    if (self){
        
        self.name = [(ModulesTree *)module name];
    }
    return self;
}

@end

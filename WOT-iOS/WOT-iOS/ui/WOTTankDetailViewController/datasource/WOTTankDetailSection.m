//
//  WOTTankDetailSection.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailSection.h"

@implementation WOTTankDetailSection

- (id)initWithTitle:(NSString *)title query:(NSString *)query metrics:(NSArray *)metrics {
    
    self = [super init];
    if (self){
        
        self.title = title;
        self.query = query;
        self.metrics = metrics;
    }
    return self;
}

@end

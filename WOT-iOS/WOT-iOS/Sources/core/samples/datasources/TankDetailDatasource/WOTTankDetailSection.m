//
//  WOTTankDetailSection.m
//  WOT-iOS
//
//  Created on 6/25/15.
//  Copyright (c) 2015. All rights reserved.
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
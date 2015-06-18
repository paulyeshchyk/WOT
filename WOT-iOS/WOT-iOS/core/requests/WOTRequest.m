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
@end

@implementation WOTRequest

- (void)executeWithArgs:(NSDictionary *)args {
    
    self.args = [args copy];
    
}

@end

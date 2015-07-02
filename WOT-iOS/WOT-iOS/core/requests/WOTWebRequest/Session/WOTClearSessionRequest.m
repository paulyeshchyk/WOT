//
//  WOTClearSessionRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTClearSessionRequest.h"
#import "UserSession.h"

@implementation WOTClearSessionRequest

- (void)executeWithArgs:(NSDictionary *)args inQueue:(NSOperationQueue *)queue{

    [super executeWithArgs:args inQueue:queue];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
    [context performBlock:^{
        
        [UserSession removeObjectsByPredicate:nil inManagedObjectContext:context];

        NSError *error = nil;
        [context save:&error];
        
        if (self.callback) {
            
            self.callback(nil, error);
        }
    }];
}

@end

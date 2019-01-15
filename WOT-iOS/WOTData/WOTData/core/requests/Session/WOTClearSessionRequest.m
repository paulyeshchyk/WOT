//
//  WOTClearSessionRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTClearSessionRequest.h"
#import <WOTData/WOTData.h>

@implementation WOTClearSessionRequest

- (void)temp_executeWithArgs:(WOTRequestArguments *)args {

    [super temp_executeWithArgs:args];
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
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

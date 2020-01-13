//
//  WOTClearSessionRequest.m
//  WOT-iOS
//
//  Created on 6/5/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTClearSessionRequest.h"
#import <WOTPivot/WOTPivot-Swift.h>
#import <WOTData/WOTData.h>
#import <WOTData/WOTData-Swift.h>

@implementation WOTClearSessionRequest

- (void)temp_executeWithArgs:(WOTRequestArguments *)args {

    [super temp_executeWithArgs:args];
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    [context performBlock:^{
        
        [UserSession removeObjectsByPredicate:nil inManagedObjectContext:context];

        NSError *error = nil;
        [context save:&error];
        
        if (self.callback) {
            
            self.callback(nil, error, nil);
        }
    }];
}

@end

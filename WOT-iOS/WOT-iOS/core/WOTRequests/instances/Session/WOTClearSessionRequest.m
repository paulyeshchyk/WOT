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

- (void)executeWithArgs:(NSDictionary *)args {

    [super executeWithArgs:args];
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    [UserSession removeObjectsByPredicate:nil inManagedObjectContext:context];
    [context save:&error];
    
    if (error){
        
        if (self.errorCallback){
            
            self.errorCallback(error);
        }
    } else {
        
        if (self.jsonCallback) {
            
            self.jsonCallback(nil);
        }
    }
}

@end

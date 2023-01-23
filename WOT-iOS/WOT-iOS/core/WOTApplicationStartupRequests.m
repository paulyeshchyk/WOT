//
//  WOTApplicationStartupRequests.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTApplicationStartupRequests.h"
#import "WOTRequestExecutor.h"
#import "Tanks.h"
#import "Vehicles.h"

@implementation WOTApplicationStartupRequests

+ (void)executeAllStartupRequests {
    
    [WOTApplicationStartupRequests executeTankListRequest];
}

+ (void)executeTankListRequest {

    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTanks registerRequestCallback:^(id data, NSError *error) {
        
        if (!error) {
            /*
             * Vehicles
             */
            [self executeVehiclesListRequest];
            
        } else {
            
            debugError(@"request-fail:%@",error.localizedDescription);
        }
    }];
    
    NSDictionary *args = @{WOT_KEY_FIELDS:[[Tanks availableFields] componentsJoinedByString:@","]};
    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTanks];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_TANK_LIST];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
    }
}


#pragma mark - private
+ (void)executeVehiclesListRequest {
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:[[Vehicles availableFields] componentsJoinedByString:@","] forKey:WOT_KEY_FIELDS];
    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTankVehicles];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_VEHICLE_LIST];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
    }
}

@end

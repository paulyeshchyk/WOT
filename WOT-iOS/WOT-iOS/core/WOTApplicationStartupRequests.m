//
//  WOTApplicationStartupRequests.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTApplicationStartupRequests.h"
#import <WOTData/WOTData.h>
#import <WOTPivot/WOTPivot.h>

#define WOT_REQUEST_ID_TANK_LIST @"WOT_REQUEST_ID_TANK_LIST"
#define WOT_REQUEST_ID_VEHICLE_LIST @"WOT_REQUEST_ID_VEHICLE_LIST"

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

    WOTRequestArguments *arguments = [[WOTRequestArguments alloc] init];
    //TODO: availableFields is internal method
    [arguments setValues:[Tanks availableFields] forKey:WOTApiKeys.fields];
    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTanks];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_TANK_LIST];
    if (canAdd) {
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:arguments];
    }
}


#pragma mark - private
+ (void)executeVehiclesListRequest {
    WOTRequestArguments *arguments = [[WOTRequestArguments alloc] init];
    [arguments setValues:[Vehicles availableFields]  forKey:WOTApiKeys.fields];

    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTankVehicles];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_VEHICLE_LIST];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:arguments];
    }
}

@end

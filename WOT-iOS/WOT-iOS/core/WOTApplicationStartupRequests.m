//
//  WOTApplicationStartupRequests.m
//  WOT-iOS
//
//  Created on 9/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTApplicationStartupRequests.h"
#import <WOTData/WOTData.h>
#import <WOTPivot/WOTPivot.h>

#define WOT_REQUEST_ID_TANK_LIST @"WOT_REQUEST_ID_TANK_LIST"
#define WOT_REQUEST_ID_VEHICLE_LIST @"WOT_REQUEST_ID_VEHICLE_LIST"

@implementation WOTApplicationStartupRequests

+ (void)executeAllStartupRequests {
    
    [WOTApplicationStartupRequests executeVehiclesListRequest];
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

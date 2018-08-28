//
//  WOTWEBRequestTankVehicles.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestTankVehicles.h"

@implementation WOTWEBRequestTankVehicles

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOT_KEY_APPLICATION_ID] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOT_KEY_FIELDS] = [NSString valueOrSpaceString:self.args[WOT_KEY_FIELDS]];
    result[WOT_KEY_TANK_ID] = [NSString valueOrSpaceString:self.args[WOT_KEY_TANK_ID]];
    return result;
}

- (NSString *)path {
    
    return @"wot/encyclopedia/vehicles/";
}


- (NSString *)method {
    
    return @"POST";
}

@end

//
//  WOTWEBRequestTankVehicles.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestTankVehicles.h"
#import "WOTDataDefines.h"

@implementation WOTWEBRequestTankVehicles

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.application_id] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
//    result[WOTApiKeys.tank_id] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.tank_id]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/vehicles/";
}


- (NSString *)method {
    
    return @"POST";
}

@end

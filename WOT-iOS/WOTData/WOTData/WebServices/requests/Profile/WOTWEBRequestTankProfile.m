//
//  WOTWEBRequestTankProfile.m
//  WOT-iOS
//
//  Created on 9/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWEBRequestTankProfile.h"
#import "WOTDataDefines.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWEBRequestTankProfile

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.application_id] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    result[WOTApiKeys.tank_id] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.tank_id]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/vehicleprofile/";
}


- (NSString *)method {
    
    return @"POST";
}

@end

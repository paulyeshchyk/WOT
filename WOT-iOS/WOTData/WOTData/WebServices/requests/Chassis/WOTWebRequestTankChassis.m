//
//  WOTWebRequestTankChassis.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebRequestTankChassis.h"
#import "WOTDataDefines.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebRequestTankChassis

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.application_id] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    result[WOTApiKeys.module_id] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.module_id]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tankchassis/";
}

@end

//
//  WOTWEBRequestTankEngines.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWEBRequestTankEngines.h"
#import "WOTDataDefines.h"

@implementation WOTWEBRequestTankEngines

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.application_id] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    result[WOTApiKeys.module_id] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.module_id]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tankengines/";
}

@end

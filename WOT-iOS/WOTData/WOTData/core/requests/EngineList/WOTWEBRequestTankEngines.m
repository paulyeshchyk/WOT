//
//  WOTWEBRequestTankEngines.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestTankEngines.h"
#import "WOTDataDefines.h"

@implementation WOTWEBRequestTankEngines

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.applicationId] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    result[WOTApiKeys.moduleId] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.moduleId]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tankengines/";
}

@end

//
//  WOTWebRequestTankChassis.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebRequestTankChassis.h"
#import "WOTDataDefines.h"

@implementation WOTWebRequestTankChassis

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.applicationId] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    result[WOTApiKeys.moduleId] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.moduleId]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tankchassis/";
}

@end

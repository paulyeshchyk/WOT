//
//  WOTWebRequestTankGuns.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebRequestTankGuns.h"
#import "WOTDataDefines.h"
//#import <WOTData/WOTData.h>

@implementation WOTWebRequestTankGuns

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.application_id] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    result[WOTApiKeys.module_id] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.module_id]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tankguns/";
}

@end

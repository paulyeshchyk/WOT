//
//  WOTWEBRequestTankEngines.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestTankEngines.h"

@implementation WOTWEBRequestTankEngines

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOT_KEY_APPLICATION_ID] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOT_KEY_FIELDS] = [NSString valueOrSpaceString:self.args[WOT_KEY_FIELDS]];
    result[WOT_KEY_MODULE_ID] = [NSString valueOrSpaceString:self.args[WOT_KEY_MODULE_ID]];
    return result;
}

- (NSString *)path {
    
    return @"wot/encyclopedia/tankengines/";
}

@end

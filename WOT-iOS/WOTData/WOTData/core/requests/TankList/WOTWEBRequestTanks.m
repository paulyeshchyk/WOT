//
//  WOTWEBRequestTanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestTanks.h"
#import "WOTDataDefines.h"

@implementation WOTWEBRequestTanks

- (NSDictionary *)query {

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOT_KEY_APPLICATION_ID] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOT_KEY_FIELDS] = [NSString valueOrSpaceString:self.args[WOT_KEY_FIELDS]];
    return result;
}

- (NSString *)path {
    
    return @"wot/encyclopedia/tanks/";
}

@end
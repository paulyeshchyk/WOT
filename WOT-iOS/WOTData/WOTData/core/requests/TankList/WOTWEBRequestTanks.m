//
//  WOTWEBRequestTanks.m
//  WOT-iOS
//
//  Created on 6/5/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWEBRequestTanks.h"
#import "WOTDataDefines.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWEBRequestTanks

- (NSDictionary *)query {

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.application_id] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tanks/";
}

@end

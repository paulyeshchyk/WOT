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
    result[WOTApiKeys.applicationId] = [NSString valueOrSpaceString:self.hostConfiguration.applicationID];
    result[WOTApiKeys.fields] = [NSString valueOrSpaceString:[self.args escapedValueForKey:WOTApiKeys.fields]];
    return result;
}

- (NSString *)path {
    
    return @"/wot/encyclopedia/tanks/";
}

@end

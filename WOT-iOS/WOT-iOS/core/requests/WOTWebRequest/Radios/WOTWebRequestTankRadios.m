//
//  WOTWebRequestTankRadios.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebRequestTankRadios.h"

@implementation WOTWebRequestTankRadios

- (NSDictionary *)query {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOT_KEY_APPLICATION_ID] = [NSString valueOrSpaceString:self.applicationID];
    result[WOT_KEY_FIELDS] = [NSString valueOrSpaceString:self.args[WOT_KEY_FIELDS]];
    result[WOT_KEY_MODULE_ID] = [NSString valueOrSpaceString:self.args[WOT_KEY_MODULE_ID]];
    return result;
}

- (NSString *)path {
    
    return @"wot/encyclopedia/tankradios/";
}

@end

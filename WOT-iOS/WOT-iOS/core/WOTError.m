//
//  WOTError.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTError.h"

@implementation WOTError

+ (NSError *)loginErrorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    
    return [NSError errorWithDomain:@"WOTLOGIN" code:code userInfo:userInfo];

}

+ (NSError *)coreDataErrorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    
    return [NSError errorWithDomain:@"WOTCOREDATA" code:code userInfo:userInfo];
}

@end

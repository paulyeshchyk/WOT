//
//  WOTWEBRequestLogout.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequest.h"

@interface WOTWEBRequestLogout : WOTWEBRequest

@property (nonatomic, readonly) NSString *applicationID;
@property (nonatomic, readonly) NSString *access_token;

@end

//
//  WOTRequestExecutor+Registration.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequestExecutor.h"

extern NSInteger const WOTRequestLoginId;
extern NSInteger const WOTRequestSaveSessionId;
extern NSInteger const WOTRequestLogoutId;

@interface WOTRequestExecutor (Registration)

+ (void)registerRequests;

@end

//
//  WOTRequestExecutor+Registration.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequestExecutor.h"

typedef NS_ENUM(NSInteger, WOTRequestId) {
    WOTRequestIdLogin = 0,
    WOTRequestIdSaveSession,
    WOTRequestIdLogout,
    WOTRequestIdClearSession,
    WOTRequestIdTanksList,
    WOTRequestIdTankEnginesList
};

@interface WOTRequestExecutor (Registration)

+ (void)registerRequests;

@end

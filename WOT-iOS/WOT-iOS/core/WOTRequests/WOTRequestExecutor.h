//
//  WOTRequestExecutor.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequest.h"

@interface WOTRequestExecutor : NSObject

+ (WOTRequestExecutor *)sharedInstance;

- (void)registerRequestClass:(Class)requestClass forRequestId:(NSInteger)requestId;
- (void)registerRequestErrorCallback:(WOTRequestErrorCallback)callback forRequestId:(NSInteger)requestId;
- (void)registerRequestJSONCallback:(WOTRequestJSONCallback)callback forRequestId:(NSInteger)requestId;

- (void)executeRequestById:(NSInteger)requestId args:(NSDictionary *)args;

@end

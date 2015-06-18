//
//  WOTRequestExecutor.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequest.h"
#import "WOTDataProviderProtocol.h"

@interface WOTRequestExecutor : NSObject

+ (WOTRequestExecutor *)sharedInstance;

- (void)requestId:(NSInteger)requestId registerRequestClass:(Class)requestClass;
- (void)requestId:(NSInteger)requestId registerDataProvider:(id<WOTDataProviderProtocol>)dataProvider;
- (void)requestId:(NSInteger)requestId registerRequestErrorCallback:(WOTRequestErrorCallback)callback;
- (void)requestId:(NSInteger)requestId registerRequestJSONCallback:(WOTRequestJSONCallback)callback;
- (void)executeRequestById:(NSInteger)requestId args:(NSDictionary *)args;

@end

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

- (void)requestId:(NSInteger)requestId registerRequestClass:(Class)requestClass;
- (void)requestId:(NSInteger)requestId registerDataAdapterClass:(Class)dataProviderClass;
- (void)requestId:(NSInteger)requestId registerRequestCallback:(WOTRequestCallback)callback;
- (WOTRequest *)requestById:(NSInteger)requestId;

- (void)addRequest:(WOTRequest *)request byGroupId:(NSString *)groupId;
- (void)cancelRequestsByGroupId:(NSString *)groupId;
- (void)removeRequest:(WOTRequest *)request;
- (void)request:(WOTRequest *)request executeWithArgs:(NSDictionary *)args;

@end

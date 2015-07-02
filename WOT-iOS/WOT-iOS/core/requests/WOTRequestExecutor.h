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
//- (void)executeRequestById:(NSInteger)requestId args:(NSDictionary *)args;
- (id)executeRequestById:(NSInteger)requestId args:(NSDictionary *)args inQueue:(NSOperationQueue *)queue;

@end

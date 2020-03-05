//
//  WOTRequestExecutor.h
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRequest.h"

@protocol WebRequestListenerProtocol;
@protocol WebHostConfigurationProtocol;
@class WOTRequest;
@class WOTRequestArguments;

typedef void(^WOTRequestCallback)(NSDictionary *json, NSError *error, NSData *binary);

@interface WOTRequestExecutor : NSObject <WebRequestListenerProtocol>
+ (NSString *)pendingRequestNotificationName;
+ (WOTRequestExecutor *)sharedInstance;

@property (nonatomic, readonly)NSInteger pendingRequestsCount;
@property (nonatomic, strong) id<WebHostConfigurationProtocol> hostConfiguration;


- (void)requestId:(NSInteger)requestId registerRequestClass:(Class)requestClass;
- (void)requestId:(NSInteger)requestId registerDataAdapterClass:(Class)dataProviderClass;
- (void)requestId:(NSInteger)requestId registerRequestCallback:(WOTRequestCallback)callback;
- (WOTRequest *)createRequestForId:(NSInteger)requestId;

- (BOOL)addRequest:(WOTRequest *)request byGroupId:(NSString *)groupId ;//DEPRECATED_ATTRIBUTE;
- (void)runRequest:(WOTRequest *)request withArgs:(WOTRequestArguments *)args ;//DEPRECATED_ATTRIBUTE;

- (void)cancelRequestsByGroupId:(NSString *)groupId;

@end

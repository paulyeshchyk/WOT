//
//  WOTRequestExecutor.h
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTRequestProtocol;
@protocol WOTRequestListenerProtocol;
@protocol WOTHostConfigurationProtocol;
@class WOTRequest;
@class WOTRequestArguments;

typedef void(^WOTRequestCallback)(NSError *error, NSData *binary);

@interface WOTRequestExecutor : NSObject <WOTRequestListenerProtocol>
+ (NSString *)pendingRequestNotificationName;
+ (WOTRequestExecutor *)sharedInstance;

@property (nonatomic, readonly)NSInteger pendingRequestsCount;
@property (nonatomic, strong) id<WOTHostConfigurationProtocol> hostConfiguration;


- (id<WOTRequestProtocol>)createRequestForId:(NSInteger)requestId;

- (BOOL)add:(id<WOTRequestProtocol>)request byGroupId:(NSString *)groupId ;//DEPRECATED_ATTRIBUTE;

- (void)cancelRequestsByGroupId:(NSString *)groupId;

@end

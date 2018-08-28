//
//  WOTRequestListener.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/26/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WOTRequest.h"

@protocol WEBHostConfiguration
@property (nonatomic, readonly, nonnull) NSString *applicationID;
@property (nonatomic, readonly, nonnull) NSString *host;
@end


@protocol WOTRequestListener <NSObject>

@required

- (void)setHostConfiguration:(id<WEBHostConfiguration>)hostConfig;

- (void)requestHasFailed:(id)request;
- (void)requestHasFinishedLoadData:(id)request;
- (void)requestHasCanceled:(id)request;
- (void)requestHasStarted:(id)request;
- (void)removeRequest:(id)request;


@end

//
//  WOTRequestListener.h
//  WOT-iOS
//
//  Created on 8/26/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WOTRequest.h"

@protocol WEBHostConfiguration
@property (nonatomic, readonly, nonnull) NSString *applicationID;
@property (nonatomic, readonly, nonnull) NSString *host;
@property (nonatomic, readonly, nonnull) NSString *scheme;
@end


@protocol WOTRequestListener <NSObject>

@required

@property (nonatomic, strong) id<WEBHostConfiguration> hostConfiguration;

- (void)requestHasFinishedLoadData:(id)request error: (NSError *) error;
- (void)requestHasCanceled:(id _Nullable )request;
- (void)requestHasStarted:(id _Nullable )request;
- (void)removeRequest:(id _Nullable )request;


@end

//
//  WOTRequestListener.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/26/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequest.h"

@protocol WOTRequestListener <NSObject>

@required

- (void)requestHasFailed:(id)request;
- (void)requestHasFinishedLoadData:(id)request;
- (void)requestHasCanceled:(id)request;
- (void)requestHasStarted:(id)request;
- (void)removeRequest:(id)request;


@end

//
//  WOTWEBRequest.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequest.h"

@interface WOTWEBRequest : WOTRequest

@property (nonatomic, readonly) NSString *host;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSDictionary *query;
@property (nonatomic, readonly) NSString *method;
@property (nonatomic, copy) NSString *headers;
@property (nonatomic, readonly) NSDictionary *userInfo;
@property (nonatomic, readonly) NSData *httpBodyData;
@property (nonatomic, readonly) NSURL *url;

- (NSString *)queryIntoString ;


@property (nonatomic, readonly) NSString *applicationID;


@end

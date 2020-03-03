//
//  WOTWEBRequest.h
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#define WOT_KEY_STATUS @"status"
#define WOT_KEY_ERROR @"error"

#import "WOTRequest.h"


@interface WOTWEBRequest : WOTRequest <NSURLConnectionDataDelegate>

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSDictionary *query;
@property (nonatomic, readonly) NSString *method;
@property (nonatomic, copy) NSString *headers;
@property (nonatomic, readonly, nullable) NSDictionary *userInfo;
@property (nonatomic, readonly) NSData *httpBodyData;
@property (nonatomic, strong) NSMutableData *data;

- (NSString * __nullable)queryIntoString;
- (NSURL * __nullable)composedURL;
- (NSURLRequest * __nullable)finalRequest;
//- (NSError * __nullable)parseData:(NSData *)data;
- (void)notifyListenersAboutFinish;

@end

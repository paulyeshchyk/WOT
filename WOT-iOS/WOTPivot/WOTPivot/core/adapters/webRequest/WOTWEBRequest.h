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


@interface WOTWEBRequest : WOTRequest

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSDictionary *query;
@property (nonatomic, readonly) NSString *method;
@property (nonatomic, copy) NSString *headers;
@property (nonatomic, readonly) NSDictionary *userInfo;
@property (nonatomic, readonly) NSData *httpBodyData;
@property (nonatomic, strong) NSMutableData *data;

- (NSString *)queryIntoString;
- (NSURL *)composedURL;
- (NSURLRequest *)finalRequest;
- (void)parseData:(NSData *)data error:(NSError *)connectionError;
- (void)notifyListenersAboutFinish;

@end

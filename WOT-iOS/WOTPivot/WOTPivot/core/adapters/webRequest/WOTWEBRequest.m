//
//  WOTWEBRequest.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWEBRequest.h"
#import "WOTRequestExecutor.h"
#import "NSMutableDictionary+WOT.h"
#import "NSBundle+LanguageBundle.h"
#import "WOTLogger.h"
#import <WOTPivot/WOTPivot-Swift.h>

/**
 description: interactive https://developers.wargaming.net/reference/all/wot/encyclopedia/tankradios/?application_id=e3a1e0889ff9c76fa503177f351b853c&fields=name%2Cmodule_id%2Cdistance%2Cnation%2Cprice_credit%2Cprice_gold&module_id=55&r_realm=ru&run=1
 */

@interface WOTWEBRequest ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, copy) NSURL *url;

@end

@implementation WOTWEBRequest

+ (NSOperationQueue *)requestQueue {

    static NSOperationQueue *_requestQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestQueue = [NSOperationQueue new];
    });
    
    return _requestQueue;
}

- (id)init {
    
    self = [super init];
    if (self){
        
        self.data = nil;
    }
    return self;
}

- (void)dealloc {
    
    self.data = nil;
}

- (NSUInteger)hash {

    NSUInteger urlHash = [[self queryIntoString] hash];
    NSUInteger argHash = [[self.args description] hash];
    return  urlHash ^ argHash;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"WOTWebRequest:%@",[self.url absoluteString]];
}

+ (NSString *)instanceClassName {
    return @"";
}

- (NSString *)method {
    
    return @"GET";
}

- (NSURL *)composedURL {
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = self.hostConfiguration.scheme;
    components.host = self.hostConfiguration.host;
    components.path = self.path;

#warning implement bodydata for POST
    NSData *bodyData = self.httpBodyData;
    if (!bodyData) {
        
        components.query = [self queryIntoString];
    }

    self.url = [components URL];

    return self.url;
}

- (NSURLRequest * __nullable)finalRequest {
    NSURL *url = [self composedURL];
    NSData *bodyData = self.httpBodyData;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval: 0];
    [request setHTTPMethod:self.method];
    
    return request;
}

- (void)temp_executeWithArgs:(WOTRequestArguments * _Nonnull)args {
    
    [super temp_executeWithArgs:args];

    NSCAssert(self.availableInGroups, @"execution group is unknown");
    
    NSURLRequest *request = [self finalRequest];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];

    [self.listeners enumerateObjectsUsingBlock:^(id  _Nonnull listener, NSUInteger idx, BOOL * _Nonnull stop) {
        [listener requestHasStarted:self];
    }];

}

- (void)cancel {
    
    [self.connection cancel];
    [self.listeners enumerateObjectsUsingBlock:^(id  _Nonnull listener, NSUInteger idx, BOOL * _Nonnull stop) {
        [listener requestHasCanceled:self];
    }];
}

- (void)cancelAndRemoveFromQueue {
    
    [self cancel];
}

#pragma mark -
- (NSString *)queryIntoString {

    NSMutableArray *queryArgs = [[NSMutableArray alloc] init];
    NSDictionary *query = self.query;
    for (NSString *key in [query allKeys]) {
        
        NSString *arg = [key urlEncoded];
        NSString *value = query[key];
        [queryArgs addObject:[NSString stringWithFormat:@"%@=%@", arg, value]];
    }
    return [queryArgs componentsJoinedByString:@"&"];
}


- (void)notifyListenersAboutFinish {
    [self.listeners enumerateObjectsUsingBlock:^(id  _Nonnull listener, NSUInteger idx, BOOL * _Nonnull stop) {

        [listener requestHasFinishedLoadData:self];
    }];
}

- (void)notifyListenersAboutFail {
    [self.listeners enumerateObjectsUsingBlock:^(id  _Nonnull listener, NSUInteger idx, BOOL * _Nonnull stop) {

        [listener requestHasFinishedLoadData:self];
    }];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseWithData:self.data];
    self.data = nil;

    [self notifyListenersAboutFinish];
}

- (void)appendData:(NSData *)data {
    if (self.data == nil) {
        self.data = [[NSMutableData alloc] init];
    }
    [self.data appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

//    NSData *stubs = [self stubs];
//    if ([stubs length] != 0) {
//
//        [self appendData: stubs];
//
//        [self notifyListenersAboutFinish];
//        [self parseData:self.data error:nil];
//        self.data = nil;
//    } else {

        [self notifyListenersAboutFail];
        [self parseWithData: nil];
        self.data = nil;
//    }
}

@end

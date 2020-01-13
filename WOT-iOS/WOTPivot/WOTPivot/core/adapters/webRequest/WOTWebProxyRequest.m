//
//  WOTWebProxyRequest.m
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 1/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebProxyRequest.h"

@implementation WOTWebProxyRequest

- (NSURLRequest *)finalRequest {
    NSURL *url = [self composedURL];
    NSData *bodyData = self.httpBodyData;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval: 0];
    [request setHTTPMethod:self.method];
    
    NSURLRequest *proxy = [self proxy:request];
    return proxy;
}


- (NSURLRequest *)proxy:(NSURLRequest *)request {
    NSURL *url = request.URL;

    NSURLQueryItem *urlItem = [[NSURLQueryItem alloc] initWithName:@"url" value:url.absoluteString];
    NSURLQueryItem *toItem = [[NSURLQueryItem alloc] initWithName:@"to" value:@"to-txt"];

    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:@"https://countwordsfree.com/loadweb"] resolvingAgainstBaseURL:NO];
    [components setQueryItems:@[urlItem, toItem]];

    NSMutableURLRequest *result = [[NSMutableURLRequest alloc] initWithURL:components.URL];
    [result setHTTPMethod:@"POST"];
    return result;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSData *clearData = [self dataFromProxyData:self.data];
    [self parseData:clearData error:nil];
    self.data = nil;

    [self notifyListenersAboutFinish];
}


- (NSData *)dataFromProxyData:(NSData *)proxyData {

    NSError *serializationError = nil;
    NSString *iso = [[NSString alloc] initWithData:proxyData encoding:NSUTF8StringEncoding];
    NSString *unescaped = [iso stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *dutf8 = [unescaped dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:dutf8 options:NSJSONReadingMutableContainers error:&serializationError];
    if (serializationError) {
        return nil;
    }

    NSString *success = jsonData[@"Text"];
    NSData *result = [success dataUsingEncoding:NSUTF8StringEncoding];

    return result;
}

@end

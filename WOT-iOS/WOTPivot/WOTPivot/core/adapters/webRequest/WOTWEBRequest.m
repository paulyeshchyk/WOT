//
//  WOTWEBRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequest.h"
#import "WOTRequestExecutor.h"
#import "NSMutableDictionary+WOT.h"
#import "NSBundle+LanguageBundle.h"
#import "WOTLogger.h"

@interface WOTWEBRequest () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;

- (NSData *)stubs;

@end

@implementation WOTWEBRequest

static NSString *urlEncode(NSString *string) {

    NSString *encodedString = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes( NULL,
                                                                                                     (CFStringRef) string,
                                                                                                     NULL,
                                                                                                     CFSTR("%;/?¿:@&=$+,[]#!'()*<> \"\n"),
                                                                                                     kCFStringEncodingUTF8);
    return encodedString;
}

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

- (NSString *)method {
    
    return @"GET";
}


- (NSURL *)url {
    
    NSString *urlPath = [NSMutableString stringWithString:self.hostConfiguration.host];
    if (self.path) {
        
        urlPath = [NSString stringWithFormat:@"%@/%@",urlPath, self.path];
    }
    
#warning implement bodydata for POST
    NSData *bodyData = self.httpBodyData;
    if (!bodyData) {
        
        NSString *queryStr = [self queryIntoString];
        if (queryStr) {
            
            urlPath = [NSString stringWithFormat:@"%@?%@",urlPath,queryStr];
        }
    }

    return [NSURL URLWithString:urlPath];
}


- (void)temp_executeWithArgs:(NSDictionary *)args {
    
    [super temp_executeWithArgs:args];

    NSCAssert(self.availableInGroups, @"execution group is unknown");
    
    NSURL *url = self.url;
    NSData *bodyData = self.httpBodyData;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval: 0];
    [request setHTTPMethod:self.method];
    
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

- (void)finalizeWithData:(id)data error:(NSError *)error {
    
    [[WOTRequestExecutor sharedInstance] removeRequest:self];
    
    if (self.callback) {
        
        self.callback(data, error);
    }
}


#pragma mark -

- (void)parseData:(NSData *)data error:(NSError *)connectionError {
    
    if (connectionError) {
        
        [self finalizeWithData:nil error:connectionError];
    } else {
        
        NSError *serializationError = nil;
        NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)
                                                                          error:&serializationError];
        if (serializationError) {
            
            [self finalizeWithData:nil error:serializationError];
        } else {
#warning make validator
            id status = jsonData[WOT_KEY_STATUS];
            if ([status isEqualToString:WOT_KEY_ERROR]) {
                
                NSCAssert(NO, @"be sure that error was handled:%@",jsonData[WOT_KEY_ERROR]);
                NSError *error = [NSError errorWithDomain:@"WOT" code:1 userInfo:jsonData[WOT_KEY_ERROR]];
                [self finalizeWithData:nil error:error];
                
            } else {
                
                NSMutableDictionary *result = nil;
                if (jsonData) {
                    
                    result = [jsonData mutableCopy];
                } else {
                    
                    result = [[NSMutableDictionary alloc] init];
                }
                
                [result clearNullValues];
                
                [result addEntriesFromDictionary:self.userInfo];
                [self finalizeWithData:result error:nil];
            }
        }
    }
}

- (NSString *)queryIntoString {

    NSMutableArray *queryArgs = [[NSMutableArray alloc] init];
    NSDictionary *query = self.query;
    for (NSString *key in [query allKeys]) {

        [queryArgs addObject:[NSString stringWithFormat:@"%@=%@",urlEncode(key),urlEncode(query[key])]];
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
    
    debugLog(@"webrequest-received-data:%@",self);
    [self appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self parseData:self.data error:nil];
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

    NSData *stubs = [self stubs];
    if ([stubs length] != 0) {

        [self appendData: stubs];

        [self notifyListenersAboutFinish];
        [self parseData:self.data error:nil];
        self.data = nil;
    } else {

        [self notifyListenersAboutFail];
        [self parseData:nil error:error];
        self.data = nil;
    }
}

- (NSData *)stubs {
    
    NSData *result = nil;

    NSString *filename = self.stubJSON;

    if ([filename length] > 0) {
        result = [NSData dataWithContentsOfFile: WOTResourcePath(filename)];
    }

    return result;
}

@end
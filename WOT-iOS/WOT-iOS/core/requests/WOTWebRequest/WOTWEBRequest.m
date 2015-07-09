//
//  WOTWEBRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequest.h"
#import "WOTRequestExecutor.h"


@interface WOTWEBRequest () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

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

+ (NSString *)language {
    
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:WOT_USERDEFAULTS_LOGIN_LANGUAGE];
    if ([language length] == 0){
        
        return WOT_USERDEFAULTS_LOGIN_LANGUAGEVALUE_RU;
    } else {
        
        return language;
    }
}

+ (NSOperationQueue *)requestQueue {

    static NSOperationQueue *_requestQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestQueue = [NSOperationQueue new];
    });
    
    return _requestQueue;
}

- (NSUInteger)hash {

    NSUInteger urlHash = [self.url hash];
    NSUInteger argHash = [self.args hash];
    
    return  urlHash ^ argHash;
    
}

- (NSString *)description {
    
    return [self.url absoluteString];
}

- (NSString *)method {
    
    return @"GET";
}

- (NSString *)host {
    
    return [NSString stringWithFormat:@"%@.%@",@"https://api.worldoftanks",[WOTWEBRequest language]];
}

- (NSURL *)url {
    
    NSString *urlPath = [NSMutableString stringWithString:self.host];
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

- (NSString *)applicationID {
    
    return WOT_VALUE_APPLICATION_ID_RU;
}

- (void)temp_executeWithArgs:(NSDictionary *)args {

    [super temp_executeWithArgs:args];

//    NSLog(@"webrequest-start:%@-%@",self.availableInGroups, [self.url absoluteString]);
    NSURL *url = self.url;
    NSData *bodyData = self.httpBodyData;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:self.method];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];
    
}

- (void)cancel {
    
    [self.connection cancel];
    
    [[WOTRequestExecutor sharedInstance] removeRequest:self];
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
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
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
                    
                    result = [NSMutableDictionary dictionaryWithDictionary:jsonData];
                } else {
                    
                    result = [[NSMutableDictionary alloc] init];
                }
                
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

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
//    NSLog(@"webrequest-received-data:%@",[self.url absoluteString]);
    [self parseData:data error:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
//    NSLog(@"webrequest-finished:%@",[self.url absoluteString]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

//    NSLog(@"webrequest-failture:%@",[self.url absoluteString]);
    
    [self parseData:nil error:error];
}

@end

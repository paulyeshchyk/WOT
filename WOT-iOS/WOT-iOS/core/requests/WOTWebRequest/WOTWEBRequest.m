//
//  WOTWEBRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequest.h"

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

- (void)executeWithArgs:(NSDictionary *)args{
    
    
    [super executeWithArgs:args];
    
    NSURL *url = self.url;
    NSData *bodyData = self.httpBodyData;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:self.method];
    [NSURLConnection sendAsynchronousRequest:request queue:[WOTWEBRequest requestQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self parseResponse:response data:data error:connectionError];
    }];

}

#pragma mark -

- (void)parseResponse:(NSURLResponse *)response data:( NSData *)data error:(NSError *)connectionError{
    
    if (connectionError) {
        
        if (self.callback) {
            
            self.callback(nil, connectionError);
        }
    } else {
        
        NSError *serializationError = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        if (serializationError) {
            
            if (self.callback) {
                
                self.callback(nil, serializationError);
            }
        } else {
#warning make validator
            id status = jsonData[WOT_KEY_STATUS];
            if ([status isEqualToString:WOT_KEY_ERROR]) {
                
                NSError *error = [NSError errorWithDomain:@"WOT" code:1 userInfo:jsonData[WOT_KEY_ERROR]];
                if (self.callback) {
                    
                    self.callback(nil, error);
                }
            } else {

                NSMutableDictionary *result = nil;
                if (jsonData) {
                    
                    result = [NSMutableDictionary dictionaryWithDictionary:jsonData];
                } else {
                    
                    result = [[NSMutableDictionary alloc] init];
                }
                
                [result addEntriesFromDictionary:self.userInfo];
                if (self.callback) {
                    
                    self.callback(result, nil);
                }
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

@end

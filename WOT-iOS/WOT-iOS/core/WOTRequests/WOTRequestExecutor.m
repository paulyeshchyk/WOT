//
//  WOTRequestExecutor.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequestExecutor.h"

@interface WOTRequestExecutor()

@property (nonatomic, strong) NSMutableDictionary *registeredRequests;
@property (nonatomic, strong) NSMutableDictionary *registeredRequestErrorCallbacks;
@property (nonatomic, strong) NSMutableDictionary *registeredRequestJSONCallbacks;

@end

@implementation WOTRequestExecutor

+ (WOTRequestExecutor *)sharedInstance {
    
    static WOTRequestExecutor* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[WOTRequestExecutor alloc] init];
    });
    
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self){
        
        self.registeredRequests = [[NSMutableDictionary alloc] init];
        self.registeredRequestErrorCallbacks = [[NSMutableDictionary alloc] init];
        self.registeredRequestJSONCallbacks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerRequestClass:(Class)requestClass forRequestId:(NSInteger)requestId {
    
    [self.registeredRequests setObject:requestClass forKey:@(requestId)];
}

- (void)registerRequestErrorCallback:(WOTRequestErrorCallback)callback forRequestId:(NSInteger)requestId {
    
    NSMutableSet *callbacks = [self.registeredRequestErrorCallbacks[@(requestId)] mutableCopy];
    if (!callbacks){
        
        callbacks = [[NSMutableSet alloc] init];
    }
    [callbacks addObject:callback];
    self.registeredRequestErrorCallbacks[@(requestId)] = callbacks;
}


- (void)registerRequestJSONCallback:(WOTRequestJSONCallback)callback forRequestId:(NSInteger)requestId {
    
    NSMutableSet *callbacks = [self.registeredRequestJSONCallbacks[@(requestId)] mutableCopy];
    if (!callbacks){
        
        callbacks = [[NSMutableSet alloc] init];
    }
    [callbacks addObject:callback];
    self.registeredRequestJSONCallbacks[@(requestId)] = callbacks;
}

- (void)executeRequestById:(NSInteger)requestId  args:(NSDictionary *)args{
    
    
    Class RegisteredRequestClass = self.registeredRequests[@(requestId)];
    
    if ([[RegisteredRequestClass class] isSubclassOfClass:[WOTRequest class]]) {
    
        WOTRequest *request = [[RegisteredRequestClass alloc] init];
        [request setErrorCallback:^(NSError *error){
            
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                
                [self.registeredRequestErrorCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestErrorCallback obj, NSUInteger idx, BOOL *stop) {
                    
                    obj(error);
                }];
            });
        }];
        
        [request setJsonCallback:^(NSDictionary *json){
            
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                
                [self.registeredRequestJSONCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestJSONCallback obj, NSUInteger idx, BOOL *stop) {
                    
                    obj(json);
                }];
            });
        }];
        
        /**
         *
         **/
        [request executeWithArgs:args];
    } else {
        
        NSLog(@"Request %d is not registered",requestId);
    }
}

@end

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
@property (nonatomic, strong) NSMutableDictionary *registeredDataProviders;

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

- (void)dealloc {
    
    [self.registeredRequests removeAllObjects];
    [self.registeredDataProviders removeAllObjects];
    [self.registeredRequestErrorCallbacks removeAllObjects];
    [self.registeredRequestJSONCallbacks removeAllObjects];
}

- (id)init {
    
    self = [super init];
    if (self){
        
        self.registeredRequests = [[NSMutableDictionary alloc] init];
        self.registeredRequestErrorCallbacks = [[NSMutableDictionary alloc] init];
        self.registeredRequestJSONCallbacks = [[NSMutableDictionary alloc] init];
        self.registeredDataProviders = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)requestId:(NSInteger)requestId registerRequestClass:(Class)requestClass {
    
    [self.registeredRequests setObject:requestClass forKey:@(requestId)];
}

- (void)requestId:(NSInteger)requestId registerRequestErrorCallback:(WOTRequestErrorCallback)callback {
    
    NSMutableSet *callbacks = [self.registeredRequestErrorCallbacks[@(requestId)] mutableCopy];
    if (!callbacks){
        
        callbacks = [[NSMutableSet alloc] init];
    }
    [callbacks addObject:callback];
    self.registeredRequestErrorCallbacks[@(requestId)] = callbacks;
}


- (void)requestId:(NSInteger)requestId registerRequestJSONCallback:(WOTRequestJSONCallback)callback {
    
    NSMutableSet *callbacks = [self.registeredRequestJSONCallbacks[@(requestId)] mutableCopy];
    if (!callbacks){
        
        callbacks = [[NSMutableSet alloc] init];
    }
    [callbacks addObject:callback];
    self.registeredRequestJSONCallbacks[@(requestId)] = callbacks;
}

- (void)requestId:(NSInteger)requestId registerDataProvider:(id<WOTDataProviderProtocol>)dataProvider {
    
    NSPointerArray *providers = self.registeredDataProviders[@(requestId)];
    if (!providers) {
        
        providers = [[NSPointerArray alloc] init];
    }
    [providers addPointer:(__bridge void*)dataProvider];
    self.registeredDataProviders[@(requestId)] = providers;
    
}

- (void)unregisterDataProvider:(id<WOTDataProviderProtocol>)dataProvider forRequestId:(NSInteger)requestId {

    NSPointerArray *providers = self.registeredDataProviders[@(requestId)];
    [providers compact];
    
    NSInteger index = [[providers allObjects] indexOfObject:dataProvider];

    if (index != NSNotFound) {
        
        [providers removePointerAtIndex:index];
    }

    self.registeredDataProviders[@(requestId)] = providers;
    
}

- (void)executeRequestById:(NSInteger)requestId  args:(NSDictionary *)args{
    
    
    Class RegisteredRequestClass = self.registeredRequests[@(requestId)];
    
    if ([[RegisteredRequestClass class] isSubclassOfClass:[WOTRequest class]]) {
    
        WOTRequest *request = [[RegisteredRequestClass alloc] init];
        [request setErrorCallback:^(NSError *error){
            
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                
                //callbacks
                [self.registeredRequestErrorCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestErrorCallback obj, NSUInteger idx, BOOL *stop) {
                    
                    obj(error);
                }];

                //providers
                NSPointerArray *dataProviders = self.registeredDataProviders[@(requestId)];
                [dataProviders compact];
                for (id<WOTDataProviderProtocol> dataProvider in dataProviders) {
                    
                    [dataProvider parseError:error];
                }
            });
        }];
        
        [request setJsonCallback:^(NSDictionary *json){
            
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{

                //callbacks
                [self.registeredRequestJSONCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestJSONCallback obj, NSUInteger idx, BOOL *stop) {
                    
                    obj(json);
                }];

                //providers
                NSPointerArray *dataProviders = self.registeredDataProviders[@(requestId)];
                [dataProviders compact];
                for (id<WOTDataProviderProtocol> dataProvider in dataProviders) {
                    
                    [dataProvider parseData:json];
                }
                
            });
        }];
        
        /**
         *
         **/
        [request executeWithArgs:args];
    } else {
        
        NSLog(@"Request %ld is not registered",(long)requestId);
    }
}

@end

//
//  WOTRequestExecutor.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequestExecutor.h"
#import "WOTWebResponseAdapter.h"

@interface WOTRequestExecutor()

@property (nonatomic, strong) NSMutableDictionary *registeredRequests;
@property (nonatomic, strong) NSMutableDictionary *registeredRequestCallbacks;
@property (nonatomic, strong) NSMutableDictionary *registeredDataAdapters;

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
    [self.registeredDataAdapters removeAllObjects];
    [self.registeredRequestCallbacks removeAllObjects];
}

- (id)init {
    
    self = [super init];
    if (self){
        
        self.registeredRequests = [[NSMutableDictionary alloc] init];
        self.registeredRequestCallbacks = [[NSMutableDictionary alloc] init];
        self.registeredDataAdapters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)requestId:(NSInteger)requestId registerRequestClass:(Class)requestClass {
    
    [self.registeredRequests setObject:requestClass forKey:@(requestId)];
}

- (void)requestId:(NSInteger)requestId registerRequestCallback:(WOTRequestCallback)callback {
    
    NSMutableSet *callbacks = [self.registeredRequestCallbacks[@(requestId)] mutableCopy];
    if (!callbacks){
        
        callbacks = [[NSMutableSet alloc] init];
    }
    [callbacks addObject:callback];
    self.registeredRequestCallbacks[@(requestId)] = callbacks;
}

- (void)requestId:(NSInteger)requestId registerDataAdapterClass:(Class)dataProviderClass {
    
    NSMutableSet *providers = self.registeredDataAdapters[@(requestId)];
    if (!providers) {
        
        providers = [[NSMutableSet alloc] init];
    }
    [providers addObject:dataProviderClass];
    self.registeredDataAdapters[@(requestId)] = providers;
    
}

- (void)unregisterDataProviderClass:(Class)dataProviderClass forRequestId:(NSInteger)requestId {

    NSMutableArray *providers = self.registeredDataAdapters[@(requestId)];
    [providers removeObject:dataProviderClass];
    self.registeredDataAdapters[@(requestId)] = providers;
    
}

- (void)executeRequestById:(NSInteger)requestId  args:(NSDictionary *)args{

    Class RegisteredRequestClass = self.registeredRequests[@(requestId)];
    
    if (!([[RegisteredRequestClass class] isSubclassOfClass:[WOTRequest class]])) {
    
        NSLog(@"Request %ld is not registered",(long)requestId);
        return;
    }
    
    WOTRequest *request = [[RegisteredRequestClass alloc] init];
    [request setCallback:^(id data, NSError *error){
        
        //callbacks
        [self.registeredRequestCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestCallback obj, NSUInteger idx, BOOL *stop) {
            
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                
                obj(data, error);
            });
        }];

        //dataAdapters
        NSSet *dataAdapters = self.registeredDataAdapters[@(requestId)];
        
        [dataAdapters enumerateObjectsUsingBlock:^(Class class, BOOL *stop) {
            
            if (!([class conformsToProtocol:@protocol(WOTWebResponseAdapter) ])) {
                
                NSLog(@"Class %@ is not conforming protocol %@",NSStringFromClass(class),NSStringFromProtocol(@protocol(WOTWebResponseAdapter)));
            } else {
            
                dispatch_queue_t queue = dispatch_get_main_queue();
                dispatch_async(queue, ^{
                    
                    id<WOTWebResponseAdapter> adapter = [[class alloc] init];
                    [adapter parseData:data error:error];
                });
            }
        }];
    }];
    /**
     *
     **/
    [request executeWithArgs:args];
   
}

@end

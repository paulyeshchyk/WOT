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

@property (nonatomic, strong) NSMutableDictionary *grouppedRequests;

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
        self.grouppedRequests = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)cancelRequestsByGroupId:(NSString *)groupId {
    
    NSPointerArray *requests = self.grouppedRequests[groupId];
    if (requests){
        
        [requests compact];
        for (NSInteger idx = ([requests count]-1); idx>=0; idx--) {
            
            WOTRequest *request = [requests pointerAtIndex:idx];
            [request cancel];
        }
    }
}

- (void)removeRequest:(WOTRequest *)request {
    
    NSArray *groups = request.availableInGroups;
    [groups enumerateObjectsUsingBlock:^(id group, NSUInteger idx, BOOL *stop) {
        
        NSPointerArray *requests = self.grouppedRequests[group];
        [requests compact];
        
        NSInteger requestIndex = [[requests allObjects] indexOfObject:request];
        if (requestIndex != NSNotFound) {
            
            [requests removePointerAtIndex:requestIndex];
        } else {
            
            NSLog(@"attempting to remove unknown request");
        }
    }];
}

- (void)addRequest:(WOTRequest *)request byGroupId:(NSString *)groupId {
    
    NSPointerArray *requests = self.grouppedRequests[groupId];
    [requests compact];
    
    if (!requests){
        
        requests = [[NSPointerArray alloc] init];
        self.grouppedRequests[groupId] = requests;
    }
    
    NSUInteger index = [[requests allObjects] indexOfObject:request];
    if (index == NSNotFound) {
        
        [request addGroup:groupId];
        [requests addPointer:(__bridge void *)request];
    }
}

- (void)runRequest:(WOTRequest *)request withArgs:(NSDictionary *)args {

    [request temp_executeWithArgs:args];
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

- (WOTRequest *)requestById:(NSInteger)requestId {
    
    Class RegisteredRequestClass = self.registeredRequests[@(requestId)];
    
    if (!([[RegisteredRequestClass class] isSubclassOfClass:[WOTRequest class]])) {
        
        NSLog(@"Request %ld is not registered",(long)requestId);
        return nil;
    }
    
    __weak typeof(self)weakSelf = self;
    
    WOTRequest *request = [[RegisteredRequestClass alloc] init];
    [request setCallback:^(id data, NSError *error){
        
        //callbacks
        [weakSelf.registeredRequestCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestCallback obj, NSUInteger idx, BOOL *stop) {
            
            obj(data, error);
        }];
        
        //dataAdapters
        NSSet *dataAdapters = weakSelf.registeredDataAdapters[@(requestId)];
        
        [dataAdapters enumerateObjectsUsingBlock:^(Class class, BOOL *stop) {
            
            if (!([class conformsToProtocol:@protocol(WOTWebResponseAdapter) ])) {
                
                NSLog(@"Class %@ is not conforming protocol %@",NSStringFromClass(class),NSStringFromProtocol(@protocol(WOTWebResponseAdapter)));
            } else {
                
                id<WOTWebResponseAdapter> adapter = [[class alloc] init];
                [adapter parseData:data error:nil];
            }
        }];
    }];
    
    return request;
}

@end

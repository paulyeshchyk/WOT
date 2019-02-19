//
//  WOTRequestExecutor.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRequestExecutor.h"
#import "WOTLogger.h"
#import <WOTPivot/WOTPivot-Swift.h>

@interface WOTRequestExecutor()

@property (nonatomic, strong) NSMutableDictionary *registeredRequests;
@property (nonatomic, strong) NSMutableDictionary *registeredRequestCallbacks;
@property (nonatomic, strong) NSMutableDictionary *registeredDataAdapters;
@property (nonatomic, strong) NSMutableDictionary *grouppedRequests;
@property (nonatomic, readwrite, assign) NSInteger pendingRequestsCount;
@property (nonatomic, strong) id<WEBHostConfiguration> hostConfiguration;
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

+ (NSString *)pendingRequestNotificationName {
    return @"WOTRequestExecutorPendingRequestNotificationName";
}

- (void)dealloc {
    
    [self.registeredRequests removeAllObjects];
    [self.registeredDataAdapters removeAllObjects];
    [self.registeredRequestCallbacks removeAllObjects];
}

- (id)init {
    
    self = [super init];
    if (self){
        
        self.pendingRequestsCount = 0;
        self.registeredRequests = [[NSMutableDictionary alloc] init];
        self.registeredRequestCallbacks = [[NSMutableDictionary alloc] init];
        self.registeredDataAdapters = [[NSMutableDictionary alloc] init];
        self.grouppedRequests = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setHostConfig:(id<WEBHostConfiguration>)config {
    self.hostConfiguration = config;
}

- (void)setPendingRequestsCount:(NSInteger)pendingRequestsCount {
    _pendingRequestsCount = pendingRequestsCount;
    NSString *notificationName = [WOTRequestExecutor pendingRequestNotificationName];
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationName object:self];
}

- (void)cancelRequestsByGroupId:(NSString *)groupId {
    
    NSPointerArray *requests = self.grouppedRequests[groupId];
    if ([requests count] == 0){

        return;
    }
    
    [requests compact];
    for (NSInteger idx = ([requests count]-1); idx>=0; idx--) {
        
        WOTRequest *request = [requests pointerAtIndex:idx];
        [request cancel];
        [requests removePointerAtIndex:idx];
    }
    
    NSCAssert(([requests count] == 0), @"requestsArray is not empty after cancelation");
}

- (void)requestsArray:(NSPointerArray *)requests removeRequest:(WOTRequest *)request {
    
    [requests compact];
    
    NSCAssert([requests count] != 0, @"requestsArray is empty");
    
    NSInteger requestIndex = [[requests allObjects] indexOfObject:request];
    if (requestIndex != NSNotFound) {
        
        [requests removePointerAtIndex:requestIndex];
    } else {
        
        debugError(@"attempting to remove unknown request:%@",request);
    }
}

- (BOOL)addRequest:(WOTRequest *)request byGroupId:(NSString *)groupId {
    
    NSPointerArray *requests = self.grouppedRequests[groupId];
    [requests compact];
    
    if (!requests){
        
        requests = [[NSPointerArray alloc] init];
        self.grouppedRequests[groupId] = requests;
    }
    
    NSUInteger index = [[requests allObjects] indexOfObjectPassingTest:^BOOL(WOTRequest *testingRequest, NSUInteger idx, BOOL *stop) {
        
        BOOL isEqual = [testingRequest isEqual:request];
        if (isEqual) {
            
            *stop = YES;
        }
        return isEqual;
    }];
    
    BOOL canAdd = (index == NSNotFound);
    if (canAdd) {
        [request addListener: self];
        [request addGroup:groupId];
        [requests addPointer:(__bridge void *)request];
    } else {
        
        debugLog(@"request has not been added:%@",request.description);
    }
    return canAdd;
}

- (void)runRequest:(WOTRequest *)request withArgs:(WOTRequestArguments *)args {

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

- (WOTRequest *)createRequestForId:(NSInteger)requestId {
    
    Class RegisteredRequestClass = self.registeredRequests[@(requestId)];
    
    if (!([[RegisteredRequestClass class] isSubclassOfClass:[WOTRequest class]])) {
        
        debugError(@"Request %ld is not registered",(long)requestId);
        return nil;
    }
    
    __weak typeof(self)weakSelf = self;
    
    WOTRequest *request = [[RegisteredRequestClass alloc] init];
    __weak typeof(request)weakRequest = request;

    request.hostConfiguration = self.hostConfiguration;

    [request setCallback:^(id data, NSError *error){
        
        //callbacks
        [weakSelf.registeredRequestCallbacks[@(requestId)] enumerateObjectsUsingBlock:^(WOTRequestCallback obj, NSUInteger idx, BOOL *stop) {
            
            obj(data, error);
        }];
        
        //dataAdapters
        NSSet *dataAdapters = weakSelf.registeredDataAdapters[@(requestId)];
        
        [dataAdapters enumerateObjectsUsingBlock:^(Class class, BOOL *stop) {
            
            if (!([class conformsToProtocol:@protocol(WOTWebResponseAdapter) ])) {
                
                debugError(@"Class %@ is not conforming protocol %@",NSStringFromClass(class),NSStringFromProtocol(@protocol(WOTWebResponseAdapter)));
            } else {
                
                if (![data isKindOfClass:[NSDictionary class]]) {
                    
                    debugError(@"%@\n%@\n\n in request:%@\n\n",error.localizedDescription,error.userInfo,weakRequest.description);

                } else {
                
                    id<WOTWebResponseAdapter> adapter = [[class alloc] init];
                    [adapter parseData:data error:nil];
                }
            }
        }];
    }];
    
    return request;
}

#pragma mark - WOTRequestListener

- (void)requestHasFailed:(id)request {

    self.pendingRequestsCount -= 1;
    [(WOTRequest *)request removeListener:self];
    debugError(@"webrequest-failture:%@",request);
}

- (void)requestHasFinishedLoadData:(id)request {
    
    self.pendingRequestsCount -= 1;
    debugLog(@"webrequest-finished:%@",request);
}

- (void)requestHasCanceled:(id)request {
    
    self.pendingRequestsCount -= 1;
    [(WOTRequest *)request removeListener:self];
    debugLog(@"webrequest-canceled:%@",request);
}

- (void)requestHasStarted:(id)request {
    
    self.pendingRequestsCount += 1;
    debugLog(@"webrequest-start:%@",request);
}


- (void)removeRequest:(id)request {
    
    NSCAssert([[request class] isSubclassOfClass:[WOTRequest class]], @"request is not subclass of WOTRequest class");

    NSArray *groups = [(WOTRequest *)request availableInGroups];
    [groups enumerateObjectsUsingBlock:^(id group, NSUInteger idx, BOOL *stop) {
        
        NSPointerArray *requests = self.grouppedRequests[group];
        [self requestsArray:requests removeRequest:request];
    }];
    [request removeListener:self];
}


@end

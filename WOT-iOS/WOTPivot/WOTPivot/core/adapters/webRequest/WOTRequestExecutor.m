//
//  WOTRequestExecutor.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRequestExecutor.h"
#import "WOTLogger.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTPivot/WOTPivot-Swift.h>

@interface WOTRequestExecutor()

@property (nonatomic, strong) NSMutableDictionary *grouppedRequests;
@property (nonatomic, readwrite, assign) NSInteger pendingRequestsCount;

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

- (id)init {
    
    self = [super init];
    if (self){
        
        self.pendingRequestsCount = 0;
        self.grouppedRequests = [[NSMutableDictionary alloc] init];
    }
    return self;
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
    }
    
    NSCAssert(([requests count] == 0), @"requestsArray is not empty after cancelation");
}

- (void)requestsArray:(NSPointerArray *)requests removeRequest:(id<WOTRequestProtocol>)request {
    
    [requests compact];
    
    NSCAssert([requests count] != 0, @"requestsArray is empty");
    
    NSInteger requestIndex = [[requests allObjects] indexOfObject:request];
    if (requestIndex != NSNotFound) {
        [requests removePointerAtIndex:requestIndex];
    } else {
        debugError(@"attempting to remove unknown request:%@",request);
    }
}

- (BOOL)add:(id<WOTRequestProtocol>)request byGroupId:(NSString *)groupId {
    
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
    }
    return canAdd;
}

- (id<WOTRequestProtocol>)createRequestForId:(NSInteger)requestId {

    id<WOTRequestProtocol> result =  [[WOTRequestReception sharedInstance] createRequestForRequestId:requestId];
    result.hostConfiguration = self.hostConfiguration;
    return result;
}

#pragma mark - WOTRequestListener

- (void)request:(id)request finishedLoadData:(NSData *)data error:(NSError *)error {

    Class clazz = [request class];
    
    if ([clazz conformsToProtocol:@protocol(WOTModelServiceProtocol)]) {
        id<WOTModelServiceProtocol> modelService = (id<WOTModelServiceProtocol>)clazz;
        
        NSString *modelClassName = [modelService modelClassName];
        NSArray* requestIds = [[WOTRequestReception sharedInstance] requestIdsForClass: NSClassFromString(modelClassName)];

        for (NSNumber* requestId in requestIds) {
            [[WOTRequestReception sharedInstance] requestId:[requestId integerValue] processBinary:data error:error];
        }
    }

    self.pendingRequestsCount -= 1;
    [self removeRequest:request];
}

- (void)requestHasCanceled:(id<WOTRequestProtocol>)request {
    
    self.pendingRequestsCount -= 1;
    [self removeRequest:request];
}

- (void)requestHasStarted:(id<WOTRequestProtocol>)request {
    self.pendingRequestsCount += 1;
}

- (void)removeRequest:(id<WOTRequestProtocol>)request {
    
    NSArray *groups = [request availableInGroups];
    [groups enumerateObjectsUsingBlock:^(id group, NSUInteger idx, BOOL *stop) {
        
        NSPointerArray *requests = self.grouppedRequests[group];
        [self requestsArray:requests removeRequest:request];
    }];
    [request removeListener:self];
}

@end

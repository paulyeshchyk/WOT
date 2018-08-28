//
//  WOTRequest.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequestListener.h"

typedef void(^WOTRequestCallback)(id data, NSError *error);

@interface WOTRequest : NSObject

@property (nonatomic, weak) id<WEBHostConfiguration> hostConfiguration;

@property (nonatomic, copy) WOTRequestCallback callback;
@property (nonatomic, readonly) NSDictionary *args;

@property (nonatomic, readonly)NSArray *availableInGroups;
@property (nonatomic, strong)NSMutableArray *listeners;

- (void)addListener:(id<WOTRequestListener>)listener;
- (void)removeListener:(id<WOTRequestListener>)listener;

- (void)addGroup:(NSString *)group;
- (void)removeGroup:(NSString *)group;

- (void)temp_executeWithArgs:(NSDictionary *)args ;//DEPRECATED_ATTRIBUTE;
- (void)cancel;
- (void)cancelAndRemoveFromQueue;

@end

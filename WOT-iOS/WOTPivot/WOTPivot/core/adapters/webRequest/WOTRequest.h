//
//  WOTRequest.h
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTRequestListener.h"

typedef void(^WOTRequestCallback)(NSDictionary *json, NSError *error, NSData *binary);

@interface WOTRequestArguments: NSObject
- (id)init:(NSDictionary *)dictionary;
- (void)setValues:(NSArray *)values forKey:(NSString *)key;
- (NSString *)escapedValueForKey:(NSString *)key;

@property (nonatomic, readonly) NSDictionary* asDictionary;

- (NSString *)composeQuery;

@end

@interface WOTRequest : NSObject

@property (nonatomic, weak) id<WEBHostConfiguration> hostConfiguration;

@property (nonatomic, copy) WOTRequestCallback callback;
@property (nonatomic, readonly) WOTRequestArguments *args;

@property (nonatomic, readonly)NSArray *availableInGroups;
@property (nonatomic, strong)NSMutableArray *listeners;

- (void)addListener:(id<WOTRequestListener>)listener;
- (void)removeListener:(id<WOTRequestListener>)listener;

- (void)addGroup:(NSString *)group;
- (void)removeGroup:(NSString *)group;

- (void)temp_executeWithArgs:(WOTRequestArguments *)args ;//DEPRECATED_ATTRIBUTE;
- (void)cancel;
- (void)cancelAndRemoveFromQueue;

@end

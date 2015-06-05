//
//  WOTRequest.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WOTRequestErrorCallback)(NSError *error);
typedef void(^WOTRequestJSONCallback)(NSDictionary *json);

@interface WOTRequest : NSObject

@property (nonatomic, copy)WOTRequestErrorCallback errorCallback;
@property (nonatomic, copy)WOTRequestJSONCallback jsonCallback;
@property (nonatomic, readonly)NSDictionary *args;

- (void)executeWithArgs:(NSDictionary *)args;

@end

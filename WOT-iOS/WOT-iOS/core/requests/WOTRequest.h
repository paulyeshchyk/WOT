//
//  WOTRequest.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WOTRequestCallback)(id data, NSError *error);

@interface WOTRequest : NSObject

@property (nonatomic, copy) WOTRequestCallback callback;
@property (nonatomic, readonly) NSDictionary *args;

- (void)executeWithArgs:(NSDictionary *)args;

@end

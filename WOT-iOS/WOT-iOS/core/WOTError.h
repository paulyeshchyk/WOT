//
//  WOTError.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTError : NSObject

+ (NSError *)loginErrorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
+ (NSError *)coreDataErrorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

@end

//
//  NSThread+ExecutionOnMain.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WOTMainThreadExecutionBlock)();

@interface NSThread (ExecutionOnMain)

+ (void)executeOnMainThread:(WOTMainThreadExecutionBlock)block;

@end

//
//  NSThread+ExecutionOnMain.h
//  WOT-iOS
//
//  Created on 8/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WOTMainThreadExecutionBlock)(void);

@interface NSThread (ExecutionOnMain)

+ (void)executeOnMainThread:(WOTMainThreadExecutionBlock)block;

@end

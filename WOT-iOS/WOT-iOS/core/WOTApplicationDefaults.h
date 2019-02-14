//
//  WOTApplicationDefaults.h
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTApplicationDefaults : NSObject

+ (void)registerDefaultSettings;
+ (void)registerRequests;

+ (NSString *)language;
+ (void)setLanguage:(NSString *)language;
+ (NSString *)host;
+ (NSString *)scheme;


@end

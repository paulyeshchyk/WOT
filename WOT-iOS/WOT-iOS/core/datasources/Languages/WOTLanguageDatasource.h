//
//  WOTLanguageDatasource.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTLanguageDatasource : NSObject

@property (nonatomic, readonly) NSArray *availableLanguages;

+ (WOTLanguageDatasource *)sharedInstance;

- (NSString *)langAtIndex:(NSInteger)index;
- (UIImage *)imageAtIndex:(NSInteger)index;
- (NSString *)appIdAtIndex:(NSInteger)index;

@end

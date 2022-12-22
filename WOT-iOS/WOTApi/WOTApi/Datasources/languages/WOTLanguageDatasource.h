//
//  WOTLanguageDatasource.h
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WOTLanguageDatasource : NSObject

@property (nonatomic, readonly) NSArray *_Nonnull availableLanguages;

+ (WOTLanguageDatasource * _Nonnull)sharedInstance;

- (NSString *_Nonnull)langAtIndex:(NSInteger)index;
- (UIImage *_Nonnull)imageAtIndex:(NSInteger)index;
- (NSString *_Nonnull)appIdAtIndex:(NSInteger)index;

@end

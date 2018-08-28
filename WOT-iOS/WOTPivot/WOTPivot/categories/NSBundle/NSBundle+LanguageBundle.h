//
//  NSBundle+LanguageBundle.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// receive notification when the language changes
extern NSString *const kLanguageDidChangeNotification;

/**
 * Language Support category.
 */
@interface NSBundle (LanguageBundle)

/**
 * Get to use bundle localize strings.
 * @return A bundle by default if nothing is set.
 */
+ (NSBundle *)languageBundle;

/**
 * Set the default language.
 * @return BOOL Returns YES if the language has changed
 */
+ (BOOL)setLanguageBundleWithPath:(NSString *)path;

/**
 *
 */
+ (NSString *)missedStringValueForKey:(NSString*)key;

@end

/**
 * Function for string localization
 * @param name as key
 * @return As localized string. If not available, returns the English Translation.
 */
NSString *WOTString(NSString *key);


/**
 * Function for resource localization
 * @param name as key
 * @return As localized resource. If not available, returns the English Translation.
 */
NSData *WOTResource(NSString *key);



/**
 * Function for image localization
 * @param name as key
 * @return As localized image. If not available, returns the English Translation.
 */
UIImage *WOTImage(NSString *key);

/**
 * Function for image path localization
 * @param name as key
 * @return As localized image path. If not available, returns the English Translation.
 */
NSString *WOTImagePath(NSString *path);


/**
 * Function for resource path localization
 * @param name as key
 * @return As localized resource path. If not available, returns the English Translation.
 */
NSString *WOTResourcePath(NSString *key);
//
//  NSBundle+LanguageBundle.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSBundle+LanguageBundle.h"
#import "NSString+WOTValue.h"

NSString *const kLanguageDidChangeNotification = @"kLanguageDidChangeNotification";
NSString *const kLocalizationEnglishDefaultPath = @"en";

static NSBundle *_langBundle = nil;

@implementation NSBundle (LanguageBundle)

+ (NSBundle *)languageBundle {

    if (!_langBundle) {
        return [self englishLanguageBundle];
    }

    return _langBundle;
}

+ (NSBundle *)englishLanguageBundle {
    NSString *path = [[NSBundle mainBundle] pathForResource:kLocalizationEnglishDefaultPath ofType:@"lproj"];

    return [NSBundle bundleWithPath:path];
}

+ (NSString *)missedStringValueForKey:(NSString*)key {
    
    return key;
}

// / Returns the english string associated to the passed key.
+ (NSString *)englishStringForKey:(NSString *)key {
    return [[NSBundle englishLanguageBundle] localizedStringForKey:key value:key table:nil];
}

+ (BOOL)setLanguageBundleWithPath:(NSString *)path {

    if (!path) {
        _langBundle = nil;
        return YES;
    }

    NSBundle *bundle = [NSBundle bundleWithPath:path];

    if (!bundle)
        return NO;

    _langBundle = bundle;

    return YES;
}

#pragma mark - Device

@end

NSString *WOTString(NSString *key) {
    return [[NSBundle languageBundle] localizedStringForKey:key value:[NSBundle englishStringForKey:key] table:nil];
}


NSData *WOTResource(NSString *key) {
    
    NSString *filePath = WOTResourcePath(key);
    return [NSData dataWithContentsOfFile:filePath];
    
}

NSString *WOTResourcePath(NSString *key) {

    NSString *name = [key stringByDeletingPathExtension];
    NSString *extension = [key pathExtension];
    return [[NSBundle languageBundle] pathForResource:name ofType:extension];

}

UIImage *WOTImage(NSString *key) {
    
    NSString *path = key;

    NSString *pathComponent = [[[NSBundle languageBundle] resourcePath] lastPathComponent];
    if (![NSString isEmptyAfterTrimmingWhitespaceAndNewlineCharacterSet:pathComponent]) {
        
        path = [NSString stringWithFormat:@"%@/%@",pathComponent,key];
    }
    
    return [UIImage imageNamed:path];
}
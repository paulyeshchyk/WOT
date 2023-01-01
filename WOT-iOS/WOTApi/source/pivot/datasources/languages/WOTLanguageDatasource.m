//
//  WOTLanguageDatasource.m
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTLanguageDatasource.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi-Swift.h>

@interface WOTLanguage : NSObject

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *applicationId;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) BOOL selected;

- (id)initWithLanguage:(NSString *)language applicationCode:(NSString *)applicationCode isSelected:(BOOL)isSelected;

@end

@implementation WOTLanguage

- (id)initWithLanguage:(NSString *)language applicationCode:(NSString *)applicationCode isSelected:(BOOL)isSelected{
    
    self = [super init];
    if (self){
        
        self.language = language;
        self.applicationId = applicationCode;
        self.selected = isSelected;
    }
    return self;
}

@end

@interface WOTLanguageDatasource ()

@property (nonatomic, strong, readwrite)NSArray *availableLanguages;

@end

@implementation WOTLanguageDatasource


+ (WOTLanguageDatasource * _Nonnull)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        [NSThread executeOnMainThread:^{
            
            instance = [[self alloc] init];
        }];
    });
    return instance;
}


- (id)init {
    
    self = [super init];
    if (self){

        WOTLanguage *ruLanguage = [[WOTLanguage alloc] initWithLanguage:WOTApiLanguage.ru applicationCode:@"e3a1e0889ff9c76fa503177f351b853c" isSelected:YES];
        WOTLanguage *euLanguage = [[WOTLanguage alloc] initWithLanguage:WOTApiLanguage.eu applicationCode:@"e3a1e0889ff9c76fa503177f351b853c" isSelected:NO];

        self.availableLanguages = @[ruLanguage, euLanguage];
        
    }
    return self;
}

- (NSString *)langAtIndex:(NSInteger)index {
    
    WOTLanguage *lang = [[WOTLanguageDatasource sharedInstance] availableLanguages][index];
    return lang.language;
   
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    
    WOTLanguage *lang = [[WOTLanguageDatasource sharedInstance] availableLanguages][index];
    return lang.image;
}


- (NSString *)appIdAtIndex:(NSInteger)index {
    
    WOTLanguage *lang = [[WOTLanguageDatasource sharedInstance] availableLanguages][index];
    return lang.applicationId;
}

@end

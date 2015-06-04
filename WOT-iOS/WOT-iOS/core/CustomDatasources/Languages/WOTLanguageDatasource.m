//
//  WOTLanguageDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTLanguageDatasource.h"

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


+ (WOTLanguageDatasource *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        if ([NSThread isMainThread]) {
            instance = [[self alloc] init];
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                instance = [[self alloc] init];
            });
        }
        
    });
    return instance;
}


- (id)init {
    
    self = [super init];
    if (self){

        WOTLanguage *ruLanguage = [[WOTLanguage alloc] initWithLanguage:WOT_VALUE_LANGUAGE_RU applicationCode:WOT_VALUE_APPLICATION_ID_RU isSelected:YES];
        WOTLanguage *euLanguage = [[WOTLanguage alloc] initWithLanguage:WOT_VALUE_LANGUAGE_EU applicationCode:WOT_VALUE_APPLICATION_ID_EU isSelected:NO];

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

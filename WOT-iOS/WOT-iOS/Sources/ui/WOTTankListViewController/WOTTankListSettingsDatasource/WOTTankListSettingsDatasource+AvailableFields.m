//
//  WOTTankListSettingsDatasource+AvailableFields.m
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingsDatasource+AvailableFields.h"
#import "WOTTankListSettingField.h"
#import "NSBundle+LanguageBundle.h"
#import <WOTApi/WOTApi.h>

@implementation WOTTankListSettingsDatasource (AvailableFields)

- (NSArray *)allFields {
    
    return @[
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.nation value:[NSString localization:WOT_STRING_NATION] ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.is_premium value:@"PREMUIM" ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.tier value:[NSString localization:WOT_STRING_LEVEL] ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.type value:[NSString localization:WOT_STRING_TYPE] ascending:YES]
            ];
    
    
}

- (BOOL)isFieldBusy:(id)field {
    return NO;
}

@end

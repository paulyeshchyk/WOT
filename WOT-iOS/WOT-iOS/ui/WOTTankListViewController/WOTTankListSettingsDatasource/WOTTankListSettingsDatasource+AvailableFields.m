//
//  WOTTankListSettingsDatasource+AvailableFields.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingsDatasource+AvailableFields.h"
#import "WOTTankListSettingField.h"

@implementation WOTTankListSettingsDatasource (AvailableFields)

- (NSArray *)allFields {
    
    return @[
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.nation_i18n value:WOTString(WOT_STRING_NATION_I18N) ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.is_premium value:WOTString(WOT_STRING_IS_PREMIUM) ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.level value:WOTString(WOT_STRING_LEVEL) ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.name_i18n value:WOTString(WOT_STRING_NAME_I18N) ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.short_name_i18n value:WOTString(WOT_NAME_SHORT_NAME_I18N) ascending:YES],
             [[WOTTankListSettingField alloc] initWithKey:WOTApiKeys.type_i18n value:WOTString(WOT_STRING_TYPE_I18N) ascending:YES]
            ];
    
    
}

- (BOOL)isFieldBusy:(id)field {
    return NO;
}

@end

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

- (NSArray *)availableFields {
    
    return @[[[WOTTankListSettingField alloc] initWithKey:WOT_KEY_NATION_I18N value:WOTString(WOT_STRING_NATION_I18N)],
            [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_IS_PREMIUM value:WOTString(WOT_STRING_IS_PREMIUM)],
            [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_LEVEL value:WOTString(WOT_STRING_LEVEL)],
            [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_NAME_I18N value:WOTString(WOT_STRING_NAME_I18N)],
            [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_SHORT_NAME_I18N value:WOTString(WOT_NAME_SHORT_NAME_I18N)],
            [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_TYPE_I18N value:WOTString(WOT_STRING_TYPE_I18N)]
            ];
    
    
}

@end

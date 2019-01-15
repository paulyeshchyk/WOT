//
//  Tanks+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks+FillProperties.h"

@implementation Tanks (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.tank_id = jSON[WOTApiKeys.tankId];
    self.name = jSON[WOTApiKeys.name];
    
    
    self.contour_image = jSON[WOT_KEY_CONTOUR_IMAGE];
    self.image = jSON[WOT_KEY_IMAGE];
    self.image_small = jSON[WOT_KEY_IMAGE_SMALL];
    self.is_premium = jSON[WOT_KEY_IS_PREMIUM];
    self.level = jSON[WOT_KEY_LEVEL];
    self.name_i18n = jSON[WOTApiKeys.nameI18N];
    self.nation = jSON[WOT_KEY_NATION];
    self.nation_i18n = jSON[WOT_KEY_NATION_I18N];
    self.short_name_i18n = jSON[WOT_KEY_SHORT_NAME_I18N];
    self.type = jSON[WOT_KEY_TYPE];
    self.type_i18n = jSON[WOT_KEY_TYPE_I18N];
}


+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.tankId, WOTApiKeys.name, WOT_KEY_IMAGE, WOT_KEY_CONTOUR_IMAGE, WOT_KEY_IMAGE_SMALL, WOT_KEY_IS_PREMIUM, WOT_KEY_LEVEL, WOTApiKeys.nameI18N, WOT_KEY_NATION, WOT_KEY_NATION_I18N, WOT_KEY_SHORT_NAME_I18N, WOT_KEY_TYPE, WOT_KEY_TYPE_I18N];
}

@end

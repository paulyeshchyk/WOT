//
//  Tankchassis+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tankchassis+FillProperties.h"

@implementation Tankchassis (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOT_KEY_MODULE_ID];
    self.name = jSON[WOT_KEY_NAME];

    self.level = jSON[WOT_KEY_LEVEL];
    self.max_load = jSON[WOT_KEY_MAX_LOAD];
    self.name_i18n = jSON[WOT_KEY_NAME_I18N];
    self.nation = jSON[WOT_KEY_NATION];
    self.nation_i18n = jSON[WOT_KEY_NATION_I18N];
    self.price_credit = jSON[WOT_KEY_PRICE_CREDIT];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
    self.rotation_speed = jSON[WOT_KEY_ROTATION_SPEED];
}

+ (NSArray *)availableFields {
    
    return @[WOT_KEY_NAME, WOT_KEY_MODULE_ID, WOT_KEY_LEVEL, WOT_KEY_MAX_LOAD, WOT_KEY_NAME_I18N, WOT_KEY_NATION, WOT_KEY_NATION_I18N, WOT_KEY_PRICE_CREDIT, WOT_KEY_PRICE_GOLD, WOT_KEY_ROTATION_SPEED];
}

@end

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
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];

    self.level = jSON[WOTApiKeys.level];
    self.max_load = jSON[WOT_KEY_MAX_LOAD];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.nation_i18n = jSON[WOTApiKeys.nation_i18n];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
    self.rotation_speed = jSON[WOT_KEY_ROTATION_SPEED];
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.level, WOT_KEY_MAX_LOAD, WOTApiKeys.name_i18n, WOTApiKeys.nation, WOTApiKeys.nation_i18n, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOT_KEY_ROTATION_SPEED];
}

@end

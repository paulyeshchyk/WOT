//
//  Tankengines+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tankengines+FillProperties.h"

@implementation Tankengines (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOT_KEY_MODULE_ID];
    self.name = jSON[WOT_KEY_NAME];
    
    self.fire_starting_chance = jSON[WOT_KEY_FIRE_STARTING_CHANCE];
    self.level = jSON[WOT_KEY_LEVEL];
    self.name_i18n = jSON[WOT_KEY_NAME_I18N];
    self.nation = jSON[WOT_KEY_NATION];
    self.power = jSON[WOT_KEY_POWER];
    self.price_credit = jSON[WOT_KEY_PRICE_CREDIT];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
}


+ (NSArray *)availableFields {
    
    return @[WOT_KEY_NAME_I18N,WOT_KEY_NAME,WOT_KEY_PRICE_GOLD, WOT_KEY_LEVEL, WOT_KEY_WEIGHT, WOT_KEY_NATION, WOT_KEY_POWER, WOT_KEY_PRICE_CREDIT, WOT_KEY_FIRE_STARTING_CHANCE, WOT_KEY_MODULE_ID, WOT_KEY_NATION_I18N];
}

@end

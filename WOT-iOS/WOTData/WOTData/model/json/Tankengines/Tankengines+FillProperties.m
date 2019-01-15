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
    
    self.module_id = jSON[WOTApiKeys.moduleId];
    self.name = jSON[WOTApiKeys.name];
    
    self.fire_starting_chance = jSON[WOT_KEY_FIRE_STARTING_CHANCE];
    self.level = jSON[WOT_KEY_LEVEL];
    self.name_i18n = jSON[WOTApiKeys.nameI18N];
    self.nation = jSON[WOT_KEY_NATION];
    self.power = jSON[WOT_KEY_POWER];
    self.price_credit = jSON[WOTApiKeys.priceCredit];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
}


+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.nameI18N,WOTApiKeys.name,WOT_KEY_PRICE_GOLD, WOT_KEY_LEVEL, WOT_KEY_NATION, WOT_KEY_POWER, WOTApiKeys.priceCredit, WOT_KEY_FIRE_STARTING_CHANCE, WOTApiKeys.moduleId, WOT_KEY_NATION_I18N];
}

@end

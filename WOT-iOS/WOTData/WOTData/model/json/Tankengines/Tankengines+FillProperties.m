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
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    
    self.fire_starting_chance = jSON[WOT_KEY_FIRE_STARTING_CHANCE];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.power = jSON[WOT_KEY_POWER];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
}


+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name_i18n,WOTApiKeys.name,WOTApiKeys.price_gold, WOTApiKeys.level, WOTApiKeys.nation, WOT_KEY_POWER, WOTApiKeys.price_credit, WOT_KEY_FIRE_STARTING_CHANCE, WOTApiKeys.module_id, WOTApiKeys.nation_i18n];
}

@end

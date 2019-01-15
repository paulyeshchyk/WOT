//
//  Tankradios+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tankradios+FillProperties.h"

@implementation Tankradios (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.moduleId];
    self.name = jSON[WOTApiKeys.name];
    self.distance = jSON[WOT_KEY_DISTANCE];
    self.level = jSON[WOT_KEY_LEVEL];
    self.name_i18n = jSON[WOTApiKeys.nameI18N];
    self.nation = jSON[WOT_KEY_NATION];
    self.nation_i18n = jSON[WOT_KEY_NATION_I18N];
    self.price_credit = jSON[WOTApiKeys.priceCredit];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.moduleId, WOT_KEY_DISTANCE, WOT_KEY_LEVEL, WOTApiKeys.nameI18N, WOT_KEY_NATION, WOT_KEY_NATION_I18N, WOTApiKeys.priceCredit, WOT_KEY_PRICE_GOLD];
}

@end

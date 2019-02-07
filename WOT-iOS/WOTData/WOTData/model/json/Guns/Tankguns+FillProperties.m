//
//  Tankguns+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tankguns+FillProperties.h"

@implementation Tankguns (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.moduleId];
    self.name = jSON[WOTApiKeys.name];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.nameI18N];
    self.nation = jSON[WOTApiKeys.nation];
    self.nation_i18n = jSON[WOTApiKeys.nation_i18n];
    self.price_credit = jSON[WOTApiKeys.priceCredit];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
    self.rate = jSON[WOT_KEY_RATE];
    
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.moduleId, WOTApiKeys.level, WOTApiKeys.nameI18N, WOTApiKeys.nation, WOTApiKeys.nation_i18n, WOTApiKeys.priceCredit, WOT_KEY_PRICE_GOLD, WOT_KEY_RATE];
}

@end

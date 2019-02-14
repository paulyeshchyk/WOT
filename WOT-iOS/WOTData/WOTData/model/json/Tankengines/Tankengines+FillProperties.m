//
//  Tankengines+FillProperties.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankengines+FillProperties.h"
#import <WOTPivot/WOTPivot.h>

@implementation Tankengines (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    
    self.fire_starting_chance = jSON[WOTApiKeys.fire_starting_chance];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.power = jSON[WOTApiKeys.power];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
}


+ (NSArray *)availableFields {
    return @[WOTApiKeys.name_i18n,WOTApiKeys.name,WOTApiKeys.price_gold, WOTApiKeys.level, WOTApiKeys.nation, WOTApiKeys.power, WOTApiKeys.price_credit, WOTApiKeys.fire_starting_chance, WOTApiKeys.module_id, WOTApiKeys.nation_i18n];
}

@end

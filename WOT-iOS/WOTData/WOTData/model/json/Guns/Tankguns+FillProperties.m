//
//  Tankguns+FillProperties.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tankguns+FillProperties.h"
#import <WOTPivot/WOTPivot.h>

@implementation Tankguns (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    self.level = jSON[WOTApiKeys.level];
    self.name_i18n = jSON[WOTApiKeys.name_i18n];
    self.nation = jSON[WOTApiKeys.nation];
    self.nation_i18n = jSON[WOTApiKeys.nation_i18n];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
    self.rate = jSON[WOTApiKeys.rate];
    
}

+ (NSArray *)availableFields {
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.level, WOTApiKeys.name_i18n, WOTApiKeys.nation, WOTApiKeys.nation_i18n, WOTApiKeys.price_credit, WOTApiKeys.price_gold, WOTApiKeys.rate];
}

@end

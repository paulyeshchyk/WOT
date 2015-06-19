//
//  Vehicles+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Vehicles+FillProperties.h"

@implementation Vehicles (FillProperties)


- (void)fillPropertiesFromDictioary:(NSDictionary *)jSON {
    
    self.name = jSON[WOT_KEY_NAME];
    self.nation = jSON[WOT_KEY_NATION];
    self.price_credit = jSON[WOT_KEY_PRICE_CREDIT];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
    self.short_name = jSON[WOT_KEY_SHORT_NAME];
    self.tag = jSON[WOT_KEY_TAG];
    self.tier = jSON[WOT_KEY_TIER];
    self.type = jSON[WOT_KEY_TYPE];
}


+ (NSArray *)availableFields {
    
    return @[WOT_KEY_NAME,WOT_KEY_NATION,WOT_KEY_PRICE_CREDIT, WOT_KEY_PRICE_GOLD, WOT_KEY_SHORT_NAME, WOT_KEY_TAG, WOT_KEY_TIER, WOT_KEY_TYPE];
}


@end

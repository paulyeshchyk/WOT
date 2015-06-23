//
//  Vehicles+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Vehicles+FillProperties.h"
#import "Tankengines.h"
#import "Tankchassis.h"
#import "Tanks.h"

@implementation Vehicles (FillProperties)


- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.name = jSON[WOT_KEY_NAME];
    self.nation = jSON[WOT_KEY_NATION];
    self.price_credit = jSON[WOT_KEY_PRICE_CREDIT];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
//    self.prices_xp = jSON[WOT_KEY_PRICES_XP];
    self.is_gift = jSON[WOT_KEY_IS_GIFT];
    self.is_premium = jSON[WOT_KEY_IS_PREMIUM];
    self.short_name = jSON[WOT_KEY_SHORT_NAME];
    self.tag = jSON[WOT_KEY_TAG];
    self.tier = jSON[WOT_KEY_TIER];
    self.type = jSON[WOT_KEY_TYPE];
    self.tank_id = jSON[WOT_KEY_TANK_ID];
}


+ (NSArray *)availableFields {
    
    return @[WOT_KEY_NAME,WOT_KEY_NATION,WOT_KEY_PRICE_CREDIT, WOT_KEY_PRICE_GOLD, WOT_KEY_SHORT_NAME, WOT_KEY_TAG, WOT_KEY_TIER, WOT_KEY_TYPE, WOT_LINKKEY_ENGINES, WOT_LINKKEY_SUSPENSIONS, WOT_KEY_PRICES_XP, WOT_KEY_IS_GIFT, WOT_KEY_TANK_ID];
}


+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *enginesLink = [WOTWebResponseLink linkWithClass:[Tankengines class]
                                                              requestId:WOTRequestIdTankEngines
                                                    argFieldNameToFetch:WOT_KEY_FIELDS
                                                  argFieldValuesToFetch:[Tankengines availableFields]
                                                   argFieldNameToFilter:WOT_KEY_MODULE_ID
                                                            jsonKeyName:WOT_LINKKEY_ENGINES
                                                         coredataIdName:WOT_KEY_MODULE_ID
                                                         linkItemsBlock:^(id entity, NSSet *items){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addEngines:items];
                                                         }
                                       ];

    WOTWebResponseLink *chassisLink = [WOTWebResponseLink linkWithClass:[Tankchassis class]
                                                              requestId:WOTRequestIdTankChassis
                                                    argFieldNameToFetch:WOT_KEY_FIELDS
                                                  argFieldValuesToFetch:[Tankchassis availableFields]
                                                   argFieldNameToFilter:WOT_KEY_MODULE_ID
                                                            jsonKeyName:WOT_LINKKEY_SUSPENSIONS
                                                         coredataIdName:WOT_KEY_MODULE_ID
                                                         linkItemsBlock:^(id entity, NSSet *items){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addSuspensions:items];
                                                         }
                                       ];
    
    
    
    return @[enginesLink, chassisLink];
}

@end

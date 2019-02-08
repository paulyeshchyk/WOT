//
//  Vehicles+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Vehicles+FillProperties.h"
#import <WOTData/WOTData.h>
#import <WOTPivot/WOTPivot.h>

@implementation Vehicles (FillProperties)


- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.name = jSON[WOTApiKeys.name];
    self.nation = jSON[WOTApiKeys.nation];
    self.price_credit = jSON[WOTApiKeys.priceCredit];
    self.price_gold = jSON[WOT_KEY_PRICE_GOLD];
    self.is_gift = jSON[WOT_KEY_IS_GIFT];
    self.is_premium = jSON[WOT_KEY_IS_PREMIUM];
    self.short_name = jSON[WOTApiKeys.short_name];
    self.tag = jSON[WOTApiKeys.tag];
    self.tier = jSON[WOTApiKeys.tier];
    /*
     * can be
     * lightTank, SPG, AT-SPG, heavyTank, mediumTank
     */
    self.type = jSON[WOTApiKeys.type];
    self.tank_id = jSON[WOTApiKeys.tankId];
}


+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name,WOTApiKeys.nation,WOTApiKeys.priceCredit, WOT_KEY_PRICE_GOLD, WOTApiKeys.short_name, WOTApiKeys.tag, WOTApiKeys.tier, WOTApiKeys.type, WOT_LINKKEY_ENGINES, WOT_LINKKEY_SUSPENSIONS, WOT_LINKKEY_RADIOS, WOT_LINKKEY_GUNS, WOT_LINKKEY_TURRETS, WOT_KEY_PRICES_XP, WOT_KEY_IS_GIFT, WOTApiKeys.tankId, WOT_KEY_MODULES_TREE, WOT_KEY_TRAVERSE_LEFT_ARC, WOT_KEY_TRAVERSE_RIGHT_ARC, WOT_KEY_TRAVERSE_SPEED, WOTApiKeys.default_profile];
}


+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WOTApiKeys.fields
                                                      argFieldValuesToFetch:[ModulesTree availableFields]
                                                       argFieldNameToFilter:WOTApiKeys.moduleId
                                                                jsonKeyName:WOT_LINKKEY_MODULESTREE
                                                             coredataIdName:WOTApiKeys.moduleId
                                                             linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                                 
                                                                 Vehicles *vehicles = (Vehicles *)entity;
                                                                 [vehicles addTurrets:items];
                                                             }
                                           ];
    
    
    WOTWebResponseLink *enginesLink = [WOTWebResponseLink linkWithClass:[Tankengines class]
                                                              requestId:WOTRequestIdTankEngines
                                                    argFieldNameToFetch:WOTApiKeys.fields
                                                  argFieldValuesToFetch:[Tankengines availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.moduleId
                                                            jsonKeyName:WOT_LINKKEY_ENGINES
                                                         coredataIdName:WOTApiKeys.moduleId
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addEngines:items];
                                                         }
                                       ];

    WOTWebResponseLink *chassisLink = [WOTWebResponseLink linkWithClass:[Tankchassis class]
                                                              requestId:WOTRequestIdTankChassis
                                                    argFieldNameToFetch:WOTApiKeys.fields
                                                  argFieldValuesToFetch:[Tankchassis availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.moduleId
                                                            jsonKeyName:WOT_LINKKEY_SUSPENSIONS
                                                         coredataIdName:WOTApiKeys.moduleId
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addSuspensions:items];
                                                         }
                                       ];
    
    WOTWebResponseLink *radiosLink = [WOTWebResponseLink linkWithClass:[Tankradios class]
                                                             requestId:WOTRequestIdTankRadios
                                                   argFieldNameToFetch:WOTApiKeys.fields
                                                 argFieldValuesToFetch:[Tankradios availableFields]
                                                  argFieldNameToFilter:WOTApiKeys.moduleId
                                                           jsonKeyName:WOT_LINKKEY_RADIOS
                                                        coredataIdName:WOTApiKeys.moduleId
                                                        linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                            
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addRadios:items];
                                                        }
                                       ];
    
    WOTWebResponseLink *gunsLink = [WOTWebResponseLink linkWithClass:[Tankguns class]
                                                           requestId:WOTRequestIdTankGuns
                                                 argFieldNameToFetch:WOTApiKeys.fields
                                               argFieldValuesToFetch:[Tankguns availableFields]
                                                argFieldNameToFilter:WOTApiKeys.moduleId
                                                         jsonKeyName:WOT_LINKKEY_GUNS
                                                      coredataIdName:WOTApiKeys.moduleId
                                                      linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                          
                                                          Vehicles *vehicles = (Vehicles *)entity;
                                                          [vehicles addGuns:items];
                                                        }
                                      ];
    
    
    WOTWebResponseLink *turretsLink = [WOTWebResponseLink linkWithClass:[Tankturrets class]
                                                              requestId:WOTRequestIdTankTurrets
                                                    argFieldNameToFetch:WOTApiKeys.fields
                                                  argFieldValuesToFetch:[Tankturrets availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.moduleId
                                                            jsonKeyName:WOT_LINKKEY_TURRETS
                                                         coredataIdName:WOTApiKeys.moduleId
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addTurrets:items];
                                                      }
                                    ];
    return @[enginesLink, chassisLink, radiosLink, gunsLink, turretsLink, modulesTreeLink];
}

@end

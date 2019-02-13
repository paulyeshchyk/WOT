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
#import "NSManagedObject+FillProperties.h"

@implementation Vehicles (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.name = jSON[WOTApiKeys.name];
    self.nation = jSON[WOTApiKeys.nation];
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_gold = jSON[WOTApiKeys.price_gold];
    self.is_premium = jSON[WOTApiKeys.is_premium];
    self.short_name = jSON[WOTApiKeys.short_name];
    self.tag = jSON[WOTApiKeys.tag];
    self.tier = jSON[WOTApiKeys.tier];
    /*
     * can be
     * lightTank, SPG, AT-SPG, heavyTank, mediumTank
     */
    self.type = jSON[WOTApiKeys.type];
    self.tank_id = jSON[WOTApiKeys.tank_id];
}


+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name,WOTApiKeys.nation, WOTApiKeys.type, WOTApiKeys.tag, WOTApiKeys.tier, WOTApiKeys.tank_id];//, WOTApiKeys.price_gold, WOTApiKeys.short_name, , WOT_LINKKEY_ENGINES, WOT_LINKKEY_SUSPENSIONS, WOT_LINKKEY_RADIOS, WOT_LINKKEY_GUNS, WOT_LINKKEY_TURRETS, WOT_KEY_PRICES_XP, WOT_KEY_MODULES_TREE, WOTApiKeys.default_profile];
}


+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WOTApiKeys.fields
                                                      argFieldValuesToFetch:[ModulesTree availableFields]
                                                       argFieldNameToFilter:WOTApiKeys.module_id
                                                                jsonKeyName:WOT_LINKKEY_MODULESTREE
                                                             coredataIdName:WOTApiKeys.module_id
                                                             linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                                 
                                                                 Vehicles *vehicles = (Vehicles *)entity;
                                                                 [vehicles addTurrets:items];
                                                             }
                                           ];
    
    
    WOTWebResponseLink *enginesLink = [WOTWebResponseLink linkWithClass:[Tankengines class]
                                                              requestId:WOTRequestIdTankEngines
                                                    argFieldNameToFetch:WOTApiKeys.fields
                                                  argFieldValuesToFetch:[Tankengines availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.module_id
                                                            jsonKeyName:WOT_LINKKEY_ENGINES
                                                         coredataIdName:WOTApiKeys.module_id
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addEngines:items];
                                                         }
                                       ];

    WOTWebResponseLink *chassisLink = [WOTWebResponseLink linkWithClass:[Tankchassis class]
                                                              requestId:WOTRequestIdTankChassis
                                                    argFieldNameToFetch:WOTApiKeys.fields
                                                  argFieldValuesToFetch:[Tankchassis availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.module_id
                                                            jsonKeyName:WOT_LINKKEY_SUSPENSIONS
                                                         coredataIdName:WOTApiKeys.module_id
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addSuspensions:items];
                                                         }
                                       ];
    
    WOTWebResponseLink *radiosLink = [WOTWebResponseLink linkWithClass:[Tankradios class]
                                                             requestId:WOTRequestIdTankRadios
                                                   argFieldNameToFetch:WOTApiKeys.fields
                                                 argFieldValuesToFetch:[Tankradios availableFields]
                                                  argFieldNameToFilter:WOTApiKeys.module_id
                                                           jsonKeyName:WOT_LINKKEY_RADIOS
                                                        coredataIdName:WOTApiKeys.module_id
                                                        linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                            
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addRadios:items];
                                                        }
                                       ];
    
    WOTWebResponseLink *gunsLink = [WOTWebResponseLink linkWithClass:[Tankguns class]
                                                           requestId:WOTRequestIdTankGuns
                                                 argFieldNameToFetch:WOTApiKeys.fields
                                               argFieldValuesToFetch:[Tankguns availableFields]
                                                argFieldNameToFilter:WOTApiKeys.module_id
                                                         jsonKeyName:WOT_LINKKEY_GUNS
                                                      coredataIdName:WOTApiKeys.module_id
                                                      linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                          
                                                          Vehicles *vehicles = (Vehicles *)entity;
                                                          [vehicles addGuns:items];
                                                        }
                                      ];
    
    
    WOTWebResponseLink *turretsLink = [WOTWebResponseLink linkWithClass:[Tankturrets class]
                                                              requestId:WOTRequestIdTankTurrets
                                                    argFieldNameToFetch:WOTApiKeys.fields
                                                  argFieldValuesToFetch:[Tankturrets availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.module_id
                                                            jsonKeyName:WOT_LINKKEY_TURRETS
                                                         coredataIdName:WOTApiKeys.module_id
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addTurrets:items];
                                                      }
                                    ];
    return @[enginesLink, chassisLink, radiosLink, gunsLink, turretsLink, modulesTreeLink];
}

@end

//
//  Vehicles+FillProperties.m
//  WOT-iOS
//
//  Created on 6/19/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Vehicles+FillProperties.h"
#import <WOTData/WOTData.h>
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation Vehicles (FillProperties)

+ (NSArray *)availableFields {
//, WOTApiKeys.price_gold, WOTApiKeys.short_name, WOT_KEY_PRICES_XP];
    return @[WOTApiKeys.name,
             WOTApiKeys.nation,
             WOTApiKeys.type,
             WOTApiKeys.tag,
             WOTApiKeys.tier,
             WOTApiKeys.tank_id,
             WOTApiKeys.default_profile,
             WOTApiKeys.modules_tree,
             WOTApiKeys.engines,
             WOTApiKeys.suspensions,
             WOTApiKeys.radios,
             WOTApiKeys.guns,
             WOTApiKeys.turrets];
}


+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WOTApiKeys.queryArgFields
                                                      argFieldValuesToFetch:[ModulesTree availableFields]
                                                       argFieldNameToFilter:WOTApiKeys.module_id
                                                                jsonKeyName:WOTApiKeys.modules_tree
                                                             coredataIdName:WOTApiKeys.module_id
                                                             linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                                 
                                                                 Vehicles *vehicles = (Vehicles *)entity;
                                                                 [vehicles addTurrets:items];
                                                             }
                                           ];
    
    
    WOTWebResponseLink *enginesLink = [WOTWebResponseLink linkWithClass:[Tankengines class]
                                                              requestId:WOTRequestIdTankEngines
                                                    argFieldNameToFetch:WOTApiKeys.queryArgFields
                                                  argFieldValuesToFetch:[Tankengines availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.module_id
                                                            jsonKeyName:WOTApiKeys.engines
                                                         coredataIdName:WOTApiKeys.module_id
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addEngines:items];
                                                         }
                                       ];

    WOTWebResponseLink *chassisLink = [WOTWebResponseLink linkWithClass:[Tankchassis class]
                                                              requestId:WOTRequestIdTankChassis
                                                    argFieldNameToFetch:WOTApiKeys.queryArgFields
                                                  argFieldValuesToFetch:[Tankchassis availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.module_id
                                                            jsonKeyName:WOTApiKeys.suspensions
                                                         coredataIdName:WOTApiKeys.module_id
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addSuspensions:items];
                                                         }
                                       ];
    
    WOTWebResponseLink *radiosLink = [WOTWebResponseLink linkWithClass:[Tankradios class]
                                                             requestId:WOTRequestIdTankRadios
                                                   argFieldNameToFetch:WOTApiKeys.queryArgFields
                                                 argFieldValuesToFetch:[Tankradios availableFields]
                                                  argFieldNameToFilter:WOTApiKeys.module_id
                                                           jsonKeyName:WOTApiKeys.radios
                                                        coredataIdName:WOTApiKeys.module_id
                                                        linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                            
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addRadios:items];
                                                        }
                                       ];
    
    WOTWebResponseLink *gunsLink = [WOTWebResponseLink linkWithClass:[Tankguns class]
                                                           requestId:WOTRequestIdTankGuns
                                                 argFieldNameToFetch:WOTApiKeys.queryArgFields
                                               argFieldValuesToFetch:[Tankguns availableFields]
                                                argFieldNameToFilter:WOTApiKeys.module_id
                                                         jsonKeyName:WOTApiKeys.guns
                                                      coredataIdName:WOTApiKeys.module_id
                                                      linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                          
                                                          Vehicles *vehicles = (Vehicles *)entity;
                                                          [vehicles addGuns:items];
                                                        }
                                      ];
    
    
    WOTWebResponseLink *turretsLink = [WOTWebResponseLink linkWithClass:[Tankturrets class]
                                                              requestId:WOTRequestIdTankTurrets
                                                    argFieldNameToFetch:WOTApiKeys.queryArgFields
                                                  argFieldValuesToFetch:[Tankturrets availableFields]
                                                   argFieldNameToFilter:WOTApiKeys.module_id
                                                            jsonKeyName:WOTApiKeys.turrets
                                                         coredataIdName:WOTApiKeys.module_id
                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                             
                                                             Vehicles *vehicles = (Vehicles *)entity;
                                                             [vehicles addTurrets:items];
                                                      }
                                    ];
    return @[enginesLink, chassisLink, radiosLink, gunsLink, turretsLink, modulesTreeLink];
}

@end

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
    return [Vehicles keypaths];
}


+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WGWebQueryArgs.fields
                                                      argFieldValuesToFetch:[ModulesTree keypaths]
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
                                                    argFieldNameToFetch:WGWebQueryArgs.fields
                                                  argFieldValuesToFetch:[Tankengines keypaths]
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
                                                    argFieldNameToFetch:WGWebQueryArgs.fields
                                                  argFieldValuesToFetch:[Tankchassis keypaths]
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
                                                   argFieldNameToFetch:WGWebQueryArgs.fields
                                                 argFieldValuesToFetch:[Tankradios keypaths]
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
                                                 argFieldNameToFetch:WGWebQueryArgs.fields
                                               argFieldValuesToFetch:[Tankguns keypaths]
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
                                                    argFieldNameToFetch:WGWebQueryArgs.fields
                                                  argFieldValuesToFetch:[Tankturrets keypaths]
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

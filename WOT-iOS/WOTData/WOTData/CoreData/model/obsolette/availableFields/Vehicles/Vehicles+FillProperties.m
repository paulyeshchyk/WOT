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

//@implementation Vehicles (FillProperties)
//
//+ (NSArray *)availableLinks {
//    
//    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
//                                                                  requestId:WOTRequestIdModulesTree
//                                                        argFieldNameToFetch:WGWebQueryArgs.fields
//                                                      argFieldValuesToFetch:[ModulesTree keypaths]
//                                                       argFieldNameToFilter:WGJsonFields.module_id
//                                                                jsonKeyName:WOTApiKeys.modules_tree
//                                                             coredataIdName:WGJsonFields.module_id
//                                                             linkItemsBlock:^(id entity, NSSet *items, id tag){
//                                                                 
//                                                                 Vehicles *vehicles = (Vehicles *)entity;
//                                                                 [vehicles addTurrets:items];
//                                                             }
//                                           ];
//    
//    
//    WOTWebResponseLink *enginesLink = [WOTWebResponseLink linkWithClass:[Tankengines class]
//                                                              requestId:WOTRequestIdTankEngines
//                                                    argFieldNameToFetch:WGWebQueryArgs.fields
//                                                  argFieldValuesToFetch:[Tankengines keypaths]
//                                                   argFieldNameToFilter:WGJsonFields.module_id
//                                                            jsonKeyName:WOTApiKeys.engines
//                                                         coredataIdName:WGJsonFields.module_id
//                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
//                                                             
//                                                             Vehicles *vehicles = (Vehicles *)entity;
//                                                             [vehicles addEngines:items];
//                                                         }
//                                       ];
//
//    WOTWebResponseLink *chassisLink = [WOTWebResponseLink linkWithClass:[Tankchassis class]
//                                                              requestId:WOTRequestIdTankChassis
//                                                    argFieldNameToFetch:WGWebQueryArgs.fields
//                                                  argFieldValuesToFetch:[Tankchassis keypaths]
//                                                   argFieldNameToFilter:WGJsonFields.module_id
//                                                            jsonKeyName:WOTApiKeys.suspensions
//                                                         coredataIdName:WGJsonFields.module_id
//                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
//                                                             
//                                                             Vehicles *vehicles = (Vehicles *)entity;
//                                                             [vehicles addSuspensions:items];
//                                                         }
//                                       ];
//    
//    WOTWebResponseLink *radiosLink = [WOTWebResponseLink linkWithClass:[Tankradios class]
//                                                             requestId:WOTRequestIdTankRadios
//                                                   argFieldNameToFetch:WGWebQueryArgs.fields
//                                                 argFieldValuesToFetch:[Tankradios keypaths]
//                                                  argFieldNameToFilter:WGJsonFields.module_id
//                                                           jsonKeyName:WOTApiKeys.radios
//                                                        coredataIdName:WGJsonFields.module_id
//                                                        linkItemsBlock:^(id entity, NSSet *items, id tag){
//                                                            
//                                                             Vehicles *vehicles = (Vehicles *)entity;
//                                                             [vehicles addRadios:items];
//                                                        }
//                                       ];
//    
//    WOTWebResponseLink *gunsLink = [WOTWebResponseLink linkWithClass:[Tankguns class]
//                                                           requestId:WOTRequestIdTankGuns
//                                                 argFieldNameToFetch:WGWebQueryArgs.fields
//                                               argFieldValuesToFetch:[Tankguns keypaths]
//                                                argFieldNameToFilter:WGJsonFields.module_id
//                                                         jsonKeyName:WOTApiKeys.guns
//                                                      coredataIdName:WGJsonFields.module_id
//                                                      linkItemsBlock:^(id entity, NSSet *items, id tag){
//                                                          
//                                                          Vehicles *vehicles = (Vehicles *)entity;
//                                                          [vehicles addGuns:items];
//                                                        }
//                                      ];
//    
//    
//    WOTWebResponseLink *turretsLink = [WOTWebResponseLink linkWithClass:[Tankturrets class]
//                                                              requestId:WOTRequestIdTankTurrets
//                                                    argFieldNameToFetch:WGWebQueryArgs.fields
//                                                  argFieldValuesToFetch:[Tankturrets keypaths]
//                                                   argFieldNameToFilter:WGJsonFields.module_id
//                                                            jsonKeyName:WOTApiKeys.turrets
//                                                         coredataIdName:WGJsonFields.module_id
//                                                         linkItemsBlock:^(id entity, NSSet *items, id tag){
//                                                             
//                                                             Vehicles *vehicles = (Vehicles *)entity;
//                                                             [vehicles addTurrets:items];
//                                                      }
//                                    ];
//    return @[enginesLink, chassisLink, radiosLink, gunsLink, turretsLink, modulesTreeLink];
//}
//
//@end
//
//  ModulesTree+FillProperties.m
//  WOT-iOS
//
//  Created on 7/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ModulesTree+FillProperties.h"
#import <objc/runtime.h>
#import <WOTPivot/WOTPivot.h>

@implementation ModulesTree (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.module_id];
    self.name = jSON[WOTApiKeys.name];
    
    self.price_credit = jSON[WOTApiKeys.price_credit];
    self.price_xp = jSON[WOTApiKeys.price_xp];
    self.is_default = jSON[WOTApiKeys.is_default];

    /**
     *  availableTypes
     *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
     */
    self.type = jSON[WOTApiKeys.type];
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.module_id, WOTApiKeys.price_credit, WOTApiKeys.modules_tree];
}

+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WOTApiKeys.fields
                                                      argFieldValuesToFetch:[ModulesTree availableFields]
                                                       argFieldNameToFilter:WOTApiKeys.module_id
                                                                jsonKeyName:WOTApiKeys.modules_tree
                                                             coredataIdName:WOTApiKeys.module_id
                                                             linkItemsBlock:^(id entity, NSSet *items, id tag){
                                                                 //                                                                 Vehicles *vehicles = (Vehicles *)entity;
                                                                 //                                                                 [vehicles addTurrets:items];
                                                             }
                                           ];
    return @[modulesTreeLink];
}

- (WOTModuleType)moduleType {
    
    WOTModuleType type = WOTModuleTypeUnknown;
    
    type |= self.nextEngines.hasItems ? WOTModuleTypeEngine : 0;
    type |= self.nextChassis.hasItems ? WOTModuleTypeChassis : 0;
    type |= self.nextGuns.hasItems ? WOTModuleTypeGuns : 0;
    type |= self.nextRadios.hasItems ? WOTModuleTypeRadios : 0;
    type |= self.nextTurrets.hasItems ? WOTModuleTypeTurrets : 0;
    
    return type;
}

@end

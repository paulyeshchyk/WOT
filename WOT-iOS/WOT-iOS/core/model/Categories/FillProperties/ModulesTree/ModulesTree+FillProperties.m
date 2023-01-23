//
//  ModulesTree+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "ModulesTree+FillProperties.h"
#import <objc/runtime.h>

@implementation ModulesTree (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOT_KEY_MODULE_ID];
    self.name = jSON[WOT_KEY_NAME];
    
    self.price_credit = jSON[WOT_KEY_PRICE_CREDIT];
    self.price_xp = jSON[WOT_KEY_PRICE_XP];
    self.is_default = jSON[WOT_KEY_IS_DEFAULT];

    /**
     *  availableTypes
     *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
     */
    self.type = jSON[WOT_KEY_TYPE];
}

+ (NSArray *)availableFields {
    
    return @[WOT_KEY_NAME, WOT_KEY_MODULE_ID, WOT_KEY_PRICE_CREDIT];
}

+ (NSArray *)availableLinks {
    
    WOTWebResponseLink *modulesTreeLink = [WOTWebResponseLink linkWithClass:[ModulesTree class]
                                                                  requestId:WOTRequestIdModulesTree
                                                        argFieldNameToFetch:WOT_KEY_FIELDS
                                                      argFieldValuesToFetch:[ModulesTree availableFields]
                                                       argFieldNameToFilter:WOT_KEY_MODULE_ID
                                                                jsonKeyName:WOT_LINKKEY_MODULESTREE
                                                             coredataIdName:WOT_KEY_MODULE_ID
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

//
//  ModulesTree+FillProperties.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "ModulesTree+FillProperties.h"
#import <objc/runtime.h>
#import <WOTPivot/WOTPivot.h>

@implementation ModulesTree (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.module_id = jSON[WOTApiKeys.moduleId];
    self.name = jSON[WOTApiKeys.name];
    
    self.price_credit = jSON[WOTApiKeys.priceCredit];
    self.price_xp = jSON[WOTApiKeys.priceXP];
    self.is_default = jSON[WOTApiKeys.isDefault];

    /**
     *  availableTypes
     *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
     */
    self.type = jSON[WOT_KEY_TYPE];
}

+ (NSArray *)availableFields {
    
    return @[WOTApiKeys.name, WOTApiKeys.moduleId, WOTApiKeys.priceCredit];
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

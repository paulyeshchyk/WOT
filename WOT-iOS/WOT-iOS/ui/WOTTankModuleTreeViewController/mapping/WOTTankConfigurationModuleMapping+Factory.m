//
//  WOTTankConfigurationModuleMapping+Factory.m
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping+Factory.h"
#import <WOTData/WOTData.h>

@implementation WOTTankConfigurationModuleMapping (Factory)

+ (WOTTankConfigurationModuleMapping *)engineMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.power, WOTApiKeys.fire_starting_chance] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)radiosMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.distance] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)turretMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.armor_board, WOTApiKeys.armor_forehead, WOTApiKeys.armor_fedd, WOTApiKeys.rotation_speed] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)chassisMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.max_load, WOTApiKeys.rotation_speed] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)gunMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.rate] forSection:@"Характеристика"];
    return result;
}
@end

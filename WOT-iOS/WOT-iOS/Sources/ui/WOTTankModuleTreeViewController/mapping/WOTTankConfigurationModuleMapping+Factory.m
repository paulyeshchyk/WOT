//
//  WOTTankConfigurationModuleMapping+Factory.m
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping+Factory.h"
#import <WOTApi/WOTApi.h>

@implementation WOTTankConfigurationModuleMapping (Factory)

+ (WOTTankConfigurationModuleMapping *)engineMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiFields.power, WOTApiFields.fire_starting_chance] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)radiosMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiFields.distance] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)turretMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiFields.armor_board, WOTApiFields.armor_forehead, WOTApiFields.armor_fedd, WOTApiFields.rotation_speed] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)chassisMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiFields.max_load, WOTApiFields.rotation_speed] forSection:@"Характеристика"];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)gunMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiFields.rate] forSection:@"Характеристика"];
    return result;
}
@end

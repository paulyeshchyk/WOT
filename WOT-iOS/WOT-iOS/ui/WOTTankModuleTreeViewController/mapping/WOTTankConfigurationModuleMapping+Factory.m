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
    [result setExtractor:^(ModulesTree *moduleTree){
        
        NSSet *setOfObjs = moduleTree.next_engines;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)radiosMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.distance] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){

        NSSet *setOfObjs = moduleTree.next_radios;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)turretMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.armor_board, WOTApiKeys.armor_forehead, WOTApiKeys.armor_fedd, WOTApiKeys.rotation_speed] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){

        NSSet *setOfObjs = moduleTree.next_turrets;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)chassisMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.max_load, WOTApiKeys.rotation_speed] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){

        NSSet *setOfObjs = moduleTree.next_chassis;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)gunMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WGJsonFields.module_id, WOTApiKeys.rate] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){
        
        NSSet *setOfObjs = moduleTree.next_guns;
        return [setOfObjs anyObject];
    }];
    return result;
}
@end

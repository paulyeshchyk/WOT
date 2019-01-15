//
//  WOTTankConfigurationModuleMapping+Factory.m
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping+Factory.h"
#import <WOTData/WOTData.h>

@implementation WOTTankConfigurationModuleMapping (Factory)

+ (WOTTankConfigurationModuleMapping *)engineMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOTApiKeys.moduleId, WOT_KEY_POWER, WOT_KEY_FIRE_STARTING_CHANCE] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){
        
        NSSet *setOfObjs = moduleTree.nextEngines;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)radiosMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOTApiKeys.moduleId, WOT_KEY_DISTANCE] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){

        NSSet *setOfObjs = moduleTree.nextRadios;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)turretMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOTApiKeys.moduleId, WOT_KEY_ARMOR_BOARD, WOT_KEY_ARMOR_FOREHEAD, WOT_KEY_ARMOR_FEDD, WOT_KEY_ROTATION_SPEED] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){

        NSSet *setOfObjs = moduleTree.nextTurrets;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)chassisMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOTApiKeys.moduleId, WOT_KEY_MAX_LOAD,WOT_KEY_ROTATION_SPEED] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){

        NSSet *setOfObjs = moduleTree.nextChassis;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)gunMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOTApiKeys.moduleId, WOT_KEY_RATE] forSection:@"Характеристика"];
    [result setExtractor:^(ModulesTree *moduleTree){
        
        NSSet *setOfObjs = moduleTree.nextGuns;
        return [setOfObjs anyObject];
    }];
    return result;
}
@end

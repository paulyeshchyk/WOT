//
//  WOTTankConfigurationModuleMapping+Factory.m
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping+Factory.h"
#import "ModulesTree.h"

@implementation WOTTankConfigurationModuleMapping (Factory)


+ (WOTTankConfigurationModuleMapping *)chassisMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOT_KEY_MAX_LOAD,WOT_KEY_ROTATION_SPEED] forSection:@"Характеристика"];
    [result setExtractor:^(id obj){
        
        ModulesTree *moduleTree = obj;
        NSSet *setOfObjs = moduleTree.nextChassis;
        return [setOfObjs anyObject];
    }];
    return result;
}

+ (WOTTankConfigurationModuleMapping *)gunMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOT_KEY_RATE] forSection:@"Характеристика"];
    [result setExtractor:^(id obj){
        
        ModulesTree *moduleTree = obj;
        NSSet *setOfObjs = moduleTree.nextGuns;
        return [setOfObjs anyObject];
    }];
    return result;
}
@end

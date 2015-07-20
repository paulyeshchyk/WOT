//
//  WOTTankConfigurationModuleMapping+Factory.m
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping+Factory.h"

@implementation WOTTankConfigurationModuleMapping (Factory)


+ (WOTTankConfigurationModuleMapping *)chassisMapping {
    
    WOTTankConfigurationModuleMapping *result = [[WOTTankConfigurationModuleMapping alloc] init];
    [result addFields:@[WOT_KEY_MAX_LOAD,WOT_KEY_ROTATION_SPEED] forSection:@"Характеристика"];
    [result setExtractor:^(id obj){
        
        NSSet *setOfObjs = [obj valueForKeyPath:@"nextChassis"];
        return [setOfObjs anyObject];
    }];
    return result;
}


@end

//
//  ModulesTree+PlainList.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/16/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "ModulesTree+PlainList.h"
#import "Tanks.h"

@implementation ModulesTree (PlainList)

- (NSSet *)plainListForVehicle:(id)vehicle {

    NSMutableSet *setOfModules = [[NSMutableSet alloc] init];
    [self.nextModules enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        
        [self vehicle:vehicle setOfModules:setOfModules parseModule:obj];
    }];

    return setOfModules;
}


- (BOOL)module:(ModulesTree *)module isTheSameTank:(id)vehicle {
    
    __block BOOL isTheSameTank = NO;
    [module.nextTanks enumerateObjectsUsingBlock:^(Tanks *nextTank, BOOL *stop) {
        
        isTheSameTank = ([nextTank.tank_id isEqual:vehicle]);
        if (isTheSameTank){
            
            *stop = YES;
        }
    }];
    
    return isTheSameTank;
}

- (void)vehicle:(id)vehicle setOfModules:(NSMutableSet *)setOfModules parseModule:(ModulesTree *)module {
    
    
    if ([self module:module isTheSameTank:vehicle]) {
    
        [setOfModules addObject:module];
    }
    
    [module.nextModules enumerateObjectsUsingBlock:^(ModulesTree *childModule, BOOL *stop) {
        
        if ([self module:childModule isTheSameTank:vehicle]) {
            
            [setOfModules addObject:childModule];
        }
        [self vehicle:vehicle setOfModules:setOfModules parseModule:childModule];
    }];
}

@end

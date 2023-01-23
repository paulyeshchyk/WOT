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

- (NSSet *)plainListForVehicleId:(id)vehicleId {

    NSMutableSet *setOfModules = [[NSMutableSet alloc] init];
    [self.nextModules enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        
        [self vehicleId:vehicleId setOfModules:setOfModules parseModule:obj];
    }];

    return setOfModules;
}


- (BOOL)module:(ModulesTree *)module isTheSameVehicleId:(id)vehicleId {
    
    __block BOOL isTheSameTank = NO;
    [module.nextTanks enumerateObjectsUsingBlock:^(Tanks *nextTank, BOOL *stop) {
        
        isTheSameTank = ([nextTank.tank_id isEqual:vehicleId]);
        if (isTheSameTank){
            
            *stop = YES;
        }
    }];
    
    return isTheSameTank;
}

- (void)vehicleId:(id)vehicleId setOfModules:(NSMutableSet *)setOfModules parseModule:(ModulesTree *)module {
    
    
    if ([self module:module isTheSameVehicleId:vehicleId]) {
    
        [setOfModules addObject:module];
    }
    
    [module.nextModules enumerateObjectsUsingBlock:^(ModulesTree *childModule, BOOL *stop) {
        
        if ([self module:childModule isTheSameVehicleId:vehicleId]) {
            
            [setOfModules addObject:childModule];
        }
        [self vehicleId:vehicleId setOfModules:setOfModules parseModule:childModule];
    }];
}

@end

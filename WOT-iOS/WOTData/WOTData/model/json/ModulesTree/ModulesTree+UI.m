//
//  ModulesTree+UI.m
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ModulesTree+UI.h"

@implementation ModulesTree (UI)

+ (WOTModuleType)moduleTypeFromString:(NSString *)strValue {

    WOTModuleType result = WOTModuleTypeUnknown;
    if ([strValue isEqualToString:WOT_VALUE_VEHICLE_ENGINE]) {
        
        result = WOTModuleTypeEngine;
    } else if ([strValue isEqualToString:WOT_VALUE_VEHICLE_GUN]) {
        
        result = WOTModuleTypeGuns;
    } else if ([strValue isEqualToString:WOT_VALUE_VEHICLE_TURRET]) {
        
        result = WOTModuleTypeTurrets;
    } else if ([strValue isEqualToString:WOT_VALUE_VEHICLE_CHASSIS]) {
        
        result = WOTModuleTypeChassis;
    } else if ([strValue isEqualToString:WOT_VALUE_VEHICLE_RADIO]) {
        
        result = WOTModuleTypeRadios;
    }
    return result;
}

+ (NSString *)moduleTypeStringForModuleType:(WOTModuleType)moduleType {
    
    NSString *name = nil;
    if ((moduleType & WOTModuleTypeChassis) == WOTModuleTypeChassis) {
        
        name = @"WOTModuleTypeChassis";
    } else if ((moduleType & WOTModuleTypeEngine) == WOTModuleTypeEngine) {
        
        name = @"WOTModuleTypeEngine";
    } else if ((moduleType & WOTModuleTypeGuns) == WOTModuleTypeGuns) {
        
        name = @"WOTModuleTypeGuns";
    } else if ((moduleType & WOTModuleTypeRadios) == WOTModuleTypeRadios) {
        
        name = @"WOTModuleTypeRadios";
    } else if ((moduleType & WOTModuleTypeTurrets) == WOTModuleTypeTurrets) {
        
        name = @"WOTModuleTypeTurrets";
    }
    return name;
}

- (NSURL *)localImageURL {
    
    NSString *name = [ModulesTree moduleTypeStringForModuleType:[self moduleType]];
    return [[NSBundle mainBundle] URLForResource:name withExtension:@"png"];
}

@end

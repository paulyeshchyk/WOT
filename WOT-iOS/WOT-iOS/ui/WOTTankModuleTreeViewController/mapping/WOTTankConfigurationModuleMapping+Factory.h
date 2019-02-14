//
//  WOTTankConfigurationModuleMapping+Factory.h
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping.h"

@interface WOTTankConfigurationModuleMapping (Factory)

+ (WOTTankConfigurationModuleMapping *)engineMapping;
+ (WOTTankConfigurationModuleMapping *)radiosMapping;
+ (WOTTankConfigurationModuleMapping *)turretMapping;
+ (WOTTankConfigurationModuleMapping *)chassisMapping;
+ (WOTTankConfigurationModuleMapping *)gunMapping;

@end

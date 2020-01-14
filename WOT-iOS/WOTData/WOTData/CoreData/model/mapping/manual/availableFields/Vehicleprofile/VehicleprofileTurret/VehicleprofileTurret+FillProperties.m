//
//  VehicleprofileTurret+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileTurret+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileTurret (FillProperties)

+ (NSArray *)availableFields {    
    return [VehicleprofileTurret keypaths];
}

@end

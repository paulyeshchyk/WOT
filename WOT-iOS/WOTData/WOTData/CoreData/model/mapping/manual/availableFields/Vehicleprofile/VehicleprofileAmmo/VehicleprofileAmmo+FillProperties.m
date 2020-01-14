//
//  VehicleprofileAmmo+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileAmmo+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileAmmo (FillProperties)

+ (NSArray *)availableFields {
    return [VehicleprofileAmmo keypaths];
}

@end

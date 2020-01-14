//
//  VehicleprofileGun+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileGun+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileGun (FillProperties)

+ (NSArray *)availableFields {    
    return [VehicleprofileGun keypaths];
}

@end

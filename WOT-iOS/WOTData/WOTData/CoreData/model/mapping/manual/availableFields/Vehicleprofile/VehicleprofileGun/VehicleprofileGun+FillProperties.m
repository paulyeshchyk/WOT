//
//  VehicleprofileGun+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileGun+FillProperties.h"

@implementation VehicleprofileGun (FillProperties)

+ (NSArray *)availableFields {
    
    return @[@"move_down_arc",@"caliber",@"name",@"weight",@"move_up_arc",@"fire_rate",@"dispersion",@"tag",@"reload_time",@"tier",@"aim_time"];
}

@end

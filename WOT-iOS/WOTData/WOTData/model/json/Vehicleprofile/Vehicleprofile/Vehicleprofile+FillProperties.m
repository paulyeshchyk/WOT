//
//  Vehicleprofile+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Vehicleprofile+FillProperties.h"

@implementation Vehicleprofile (FillProperties)

+ (NSArray *)availableFields {
    
    return @[@"max_ammo",@"weight",@"hp",@"is_default",@"speed_forward",@"hull_hp",@"speed_backward",@"tank_id",@"max_weight"];
}

@end

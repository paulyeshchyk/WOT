//
//  VehicleprofileGun+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileGun+FillProperties.h"

@implementation VehicleprofileGun (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {

    self.move_down_arc = jSON[@"move_down_arc"];
    self.caliber = jSON[@"caliber"];
    self.name = jSON[@"name"];
    self.weight = jSON[@"weight"];
    self.move_up_arc = jSON[@"move_up_arc"];
    self.fire_rate = jSON[@"fire_rate"];
    self.dispersion = jSON[@"dispersion"];
    self.tag = jSON[@"tag"];
    self.reload_time = jSON[@"reload_time"];
    self.tier = jSON[@"tier"];
    self.aim_time = jSON[@"aim_time"];
}

+ (NSArray *)availableFields {
    
    return @[@"move_down_arc",@"caliber",@"name",@"weight",@"move_up_arc",@"fire_rate",@"dispersion",@"tag",@"reload_time",@"tier",@"aim_time"];
}

@end

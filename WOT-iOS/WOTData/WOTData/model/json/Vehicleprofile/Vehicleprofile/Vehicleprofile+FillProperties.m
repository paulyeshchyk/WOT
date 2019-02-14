//
//  Vehicleprofile+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Vehicleprofile+FillProperties.h"

@implementation Vehicleprofile (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.max_ammo = jSON[@"max_ammo"];
    self.weight = jSON[@"weight"];
    self.hp = jSON[@"hp"];
    self.is_default = jSON[@"is_default"];
    self.hull_weight = jSON[@"hull_weight"];
    self.speed_forward = jSON[@"speed_forward"];
    self.hull_hp = jSON[@"hull_hp"];
    self.speed_backward = jSON[@"speed_backward"];
    self.tank_id = jSON[@"tank_id"];
    self.max_weight = jSON[@"max_weight"];
}

+ (NSArray *)availableFields {
    
    return @[@"max_ammo",@"weight",@"hp",@"is_default",@"speed_forward",@"hull_hp",@"speed_backward",@"tank_id",@"max_weight"];
}

@end

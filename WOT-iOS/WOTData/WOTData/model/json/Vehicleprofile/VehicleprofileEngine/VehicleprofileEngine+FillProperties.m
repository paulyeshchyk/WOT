//
//  VehicleprofileEngine+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileEngine+FillProperties.h"

@implementation VehicleprofileEngine (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)jSON {
    
    self.name = jSON[@"name"];
    self.power = jSON[@"power"];
    self.weight = jSON[@"weight"];
    self.tag = jSON[@"tag"];
    self.fire_chance = jSON[@"fire_chance"];
    self.tier = jSON[@"tier"];
    
}

+ (NSArray *)availableFields {
    
    return @[@"name",@"power",@"weight",@"tag",@"fire_chance",@"tier"];
}

@end

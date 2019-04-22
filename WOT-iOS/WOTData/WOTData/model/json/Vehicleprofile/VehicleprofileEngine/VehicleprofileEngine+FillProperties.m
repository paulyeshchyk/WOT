//
//  VehicleprofileEngine+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileEngine+FillProperties.h"

@implementation VehicleprofileEngine (FillProperties)

+ (NSArray *)availableFields {
    
    return @[@"name",@"power",@"weight",@"tag",@"fire_chance",@"tier"];
}

@end

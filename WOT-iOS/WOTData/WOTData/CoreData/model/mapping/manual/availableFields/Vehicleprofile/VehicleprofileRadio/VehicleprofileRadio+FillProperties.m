//
//  VehicleprofileRadio+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileRadio+FillProperties.h"

@implementation VehicleprofileRadio (FillProperties)

+ (NSArray *)availableFields {
    
    return @[@"tier",@"signal_range",@"tag",@"weight",@"name"];
}

@end

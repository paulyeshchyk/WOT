//
//  VehicleprofileEngine+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileEngine+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileEngine (FillProperties)

+ (NSArray *)availableFields {
    return [VehicleprofileEngine keypaths];
}

@end

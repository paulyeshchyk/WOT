//
//  VehicleprofileRadio+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileRadio+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileRadio (FillProperties)

+ (NSArray *)availableFields {
    return [VehicleprofileRadio keypaths];
}

@end

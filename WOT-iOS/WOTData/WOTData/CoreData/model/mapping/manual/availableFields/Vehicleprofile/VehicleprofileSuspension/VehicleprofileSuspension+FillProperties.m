//
//  VehicleprofileSuspension+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileSuspension+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileSuspension (FillProperties)

+ (NSArray *)availableFields {
    return [VehicleprofileSuspension keypaths];
}


@end

//
//  VehicleprofileAmmoDamage+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileAmmoDamage+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation VehicleprofileAmmoDamage (FillProperties)


+ (NSArray *)availableFields {
    
    return [VehicleprofileAmmoDamage keypaths];
}

@end

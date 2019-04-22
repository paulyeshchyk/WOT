//
//  VehicleprofileAmmoPenetration+FillProperties.m
//  WOT-iOS
//
//  Created on 9/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "VehicleprofileAmmoPenetration+FillProperties.h"

@implementation VehicleprofileAmmoPenetration (FillProperties)

+ (NSArray *)availableFields {
    
    return @[@"avg_value",@"max_value",@"min_value"];
}

@end
